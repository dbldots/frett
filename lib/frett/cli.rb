require 'optparse'

module Frett
  class CLI
    def self.execute(stdout, arguments=[])
      options = {}
      banner = "Usage: frett [options] 'search string' [directory path]"

      optparse = OptionParser.new do|opts|
        opts.banner = banner

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

        options[:vim] = nil
        opts.on( '-v', '--vim', 'produces output that can be populated into the vim quickfix buffer' ) do
          options[:vim] = true
        end

        opts.on( '-h', '--help', 'Display this screen' ) do
          puts opts
          exit
        end
      end

      optparse.parse!(arguments)
      search_options = options.inject({}) { |hsh, (key, value)| value.nil? ? hsh : hsh.merge(key => value) }
      path = File.join(Frett::Config.instance.pwd, arguments.last) if arguments.size > 1
      arguments.pop if path && File.exist?(path)
      needle = arguments.join(" ")

      unless File.exist?(File.join(Frett::Config.instance.pwd, Frett::Config.instance.options.service_name << ".pid"))
        puts "WARNING: frett_service is NOT running..".red
      end

      if needle.strip.empty?
        puts banner
      else
        Frett::Search.new(search_options).search(needle, path)
      end
    end
  end
end
