class Frett::Config

  class << self
    def default_options
      {
        :exclude => "^tags$|log\/|tmp\/",
        :num_docs => 100000,
        :directory => ".frett",
        :log => true,
        :consider_mtime => true,
        :search => {
          :use_wildcard => false,
          :escape => true,
          :use_or => false
        }
      }
    end

    def load_config(working_dir)
      @options = default_options.merge(:working_dir => working_dir)
    end

    def index_path
      File.join(File.expand_path(self.working_dir), self.directory)
    end

    def mtime_path
      File.join(index_path, 'mtime')
    end

    def method_missing(meth, *args, &block)
      @options[meth]
    end
  end

end
