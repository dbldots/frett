require 'listen'
require 'ptools'
require 'mime/types'
require 'colorize'

class Frett::Indexer

  def initialize(options = {})
    @options = options
    index!

    ::Listen.to(Frett::Config.working_dir) do |modified, added, removed|
      modified.each do |filename|
        update_file(filename)
      end

      added.each do |filename|
        update_file(filename)
      end

      removed.each do |filename|
        remove_file(filename)
      end
    end
  end

  def index!
    adapter.write do |index|
      Dir.glob(File.join(Frett::Config.working_dir, "**/*"), File::FNM_CASEFOLD) do |filename|
        if process?(filename) && needs_index?(filename)
          index_file(index, filename)
        end
      end
    end
  end

  def remove_file(filename)
    return if filename.include?(Frett::Config.directory)
    adapter.write do |index|
      remove_from_index(index, filename)
    end
  end

  def update_file(filename)
    return unless process?(filename)
    adapter.write do |index|
      remove_from_index(index, filename)
      index_file(index, filename)
    end
  end

  private

  def index_file(index, filename)
    puts "INDEX #{filename}".green
    file = File.new(filename, 'r')
    line = 1
    now = Time.now.to_i
    while (text = file.gets)
      content = text.gsub(/\n/, "").strip
      index << {
        :line => line,
        :content => content,
        :file => filename
      }
      line += 1
    end
  end

  def remove_from_index(index, filename)
    query = Ferret::Search::PrefixQuery.new(:file, filename)
    doc_ids = index.scan(query, :limit => Frett::Config.num_docs)
    puts "DELETE #{doc_ids.size} entries for #{filename}".red
    doc_ids.each do |doc_id|
      index.delete(doc_id)
    end
  end

  def needs_index?(filename)
    return true unless Frett::Config.consider_mtime
    File.mtime(filename) > File.mtime(Frett::Config.mtime_path)
  end

  def process?(filename)
    File.file?(filename) && 
      !filename.include?(Frett::Config.directory) &&
      !filename.include?(Frett::Config.service_name) &&
      !(filename =~ /.*\/(_darcs|\..+?)\/.*/) &&
      !excluded?(filename) &&
      !MIME::Types.of(filename).any? { |type| type.binary? } &&
      !File.binary?(filename)
  end

  def excluded?(filename)
    filename.gsub(File.join(Frett::Config.working_dir,"/"), '') =~ exclude_regexp
  end

  def exclude_regexp
    @exclude_regexp ||= Regexp.new(Frett::Config.exclude)
  end

  def adapter
    @adapter ||= Frett::Adapter.new(@options)
  end
end
