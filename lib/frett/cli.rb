require 'optparse'

module Frett
  class CLI
    def self.execute(stdout, arguments=[])
      options = {}

      optparse = OptionParser.new do|opts|
        opts.banner = "Usage: frett [options] 'search string'"

        options[:escape] = nil
        opts.on( '-n', '--escape', 'escape special characters' ) do
          options[:escape] = true
        end
        opts.on( '-N', '--no-escape', 
                 'don\'t escape special chars. you may want to use:',
                 '\'?\' for any character, \'*\' for multiple characters' ) do
          options[:escape] = false
        end

        options[:use_wildcard] = nil
        opts.on( '-w', '--use-wildcard', 'adds a \'*\' in front & to the end of your search string' ) do
          options[:use_wildcard] = true
        end
        opts.on( '-W', '--no-wildcard', 'don\'t wildcard the search string' ) do
          options[:use_wildcard] = false
        end

        options[:use_or] = nil
        opts.on( '-o', '--use-or', 'build search query using OR for the terms of your search string' ) do
          options[:use_or] = true
        end
        opts.on( '-a', '--use-and', 'build search query using AND for the terms of your search string' ) do
          options[:use_or] = false
        end

        opts.on( '-h', '--help', 'Display this screen' ) do
          puts opts
          exit
        end
      end

      optparse.parse!(arguments)
      search_options = options.inject({}) { |hsh, (key, value)| value.nil? ? hsh : hsh.merge(key => value) }
      needle = arguments.join(" ")

      puts "WARNING: frett_service is NOT running..".red unless File.exist?(File.join(Frett::Config.working_dir, Frett::Config.service_name << ".pid"))
      Frett::Search.new(search_options).search(needle)
    end
  end
end
