require 'listen'
require 'ptools'
require 'mime/types'
require 'colorize'

module Frett
  class Indexer

    def initialize(opts = {})
      if opts[:clean]
        Frett::Adapter::Writer.stop_sphinx
        Frett::Config.instance.clean_data_dir
      end

      index

      ::Listen.to(Frett::Config.instance.pwd) do |modified, added, removed|
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

    def adapter
      @adapter ||= Frett::Adapter::Writer.new
    end

    def index
      Dir.glob(File.join(Frett::Config.instance.pwd, "**/*"), File::FNM_CASEFOLD) do |filename|
        if process?(filename) && needs_index?(filename)
          index_file(filename)
        end
      end
    end

    def remove_file(filename)
      return if filename.include?(Frett::Config.instance.options.data_dir)
      remove_from_index(filename)
      Frett::Config.instance.update_mtime
    end

    def update_file(filename)
      return unless process?(filename)
      remove_from_index(filename)
      index_file(filename)
      Frett::Config.instance.update_mtime
    end

    private

    def index_file(filename)
      puts "INDEX #{filename}".green
      file = File.new(filename, 'r')
      line = 1
      while (text = file.gets)
        return unless text.valid_encoding?
        content = text.gsub(/\n/, "").strip
        adapter.insert(filename, line, content)
        line += 1
      end
      file.close
    end

    def remove_from_index(filename)
      puts "DELETE entries for #{filename}".red
      adapter.remove(filename)
    end

    def needs_index?(filename)
      File.mtime(filename) > Frett::Config.instance.get_mtime
    end

    def process?(filename)
      File.file?(filename) &&
        !filename.include?(Frett::Config.instance.options.data_dir) &&
        !filename.include?(Frett::Config.instance.options.service_name) &&
        !(filename =~ /.*\/(_darcs|\..+?)\/.*/) &&
        !excluded?(filename) &&
        !MIME::Types.of(filename).any? { |type| type.binary? } &&
        !File.binary?(filename)
    end

    def excluded?(filename)
      filename.gsub(File.join(Frett::Config.instance.pwd,"/"), '') =~ exclude_regexp
    end

    def exclude_regexp
      @exclude_regexp ||= Regexp.new(Frett::Config.instance.options.exclude)
    end

  end
end
