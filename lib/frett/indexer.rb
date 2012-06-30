require 'ptools'
require 'mime/types'

class Frett::Indexer

  def initialize(options = {})
    @options = options
  end

  def index!
    adapter.writer_index do |index|
      Dir.glob(File.join(Frett::Config.working_dir, "**/*"), File::FNM_CASEFOLD) do |filename|
        if process?(filename) && needs_index?(filename, index)
          index_file(index, filename)
        end
      end
    end
  end

  def options
    default_options.merge(@options)
  end

  def index_file(index, filename)
    return unless process?(filename)
    puts "INDEX #{filename}"
    file = File.new(filename, 'r')
    filename = File.expand_path(filename)
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

  def remove_file(filename)
    adapter.reader_index do |index|
      remove_from_index(filename, index)
      index.flush
    end
  end

  def update_file(filename)
    return unless process?(filename)
    adapter.writer_index(true) do |index|
      remove_from_index(filename, index)
      index_file(index, filename)
    end
  end

  private

  def needs_index?(filename, index)
    return true unless Frett::Config.consider_mtime
    File.mtime(filename) > File.mtime(Frett::Config.mtime_path)
    #mtime = File.mtime(filename).to_i.to_s
    #query = Ferret::Search::BooleanQuery.new
    #query.add_query Ferret::Search::PrefixQuery.new(:file, filename, :max_terms => 2056), :must
    #query.add_query Ferret::Search::RangeQuery.new(:indexed_at, :lower => mtime), :must
    #doc_ids = index.scan(query, :limit => 1)
    #result = doc_ids.size > 0 ? false : true
    #puts "(RE)INDEX #{filename}" if result
    #result
  end

  def process?(filename)
    File.file?(filename) && 
      !filename.include?(Frett::Config.directory) &&
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

  def remove_from_index(filename, index)
    query = Ferret::Search::PrefixQuery.new(:file, filename, :max_terms => 2056)
    puts "DELETE #{filename}"
    index.scan(query, :limit => Frett::Config.num_docs).each do |doc_id|
      index.delete(doc_id)
    end
  end

  def adapter
    @adapter ||= Frett::Adapter.new
  end
end
