require 'optparse'

module Frett
  class CLI
    def self.execute(stdout, arguments=[])
      needle = arguments.join(" ")
      Frett::Search.new.search(needle)
      exit

      mandatory_options = %w(  )
      options = {}
      parser = OptionParser.new do |opts|
        opts.banner = <<-BANNER.gsub(/^          /,'')
          Utility to build search index of a project
          Usage: #{File.basename($0)} [options]

          Options are:
        BANNER
        opts.separator ""
        opts.on("-p", "--path PATH", String,
                "This is a sample message.",
                "For multiple lines, add more strings.",
                "Default: ~") { |arg| options[:path] = arg }
        opts.on("-h", "--help",
                "Show this help message.") { stdout.puts opts; exit }
        opts.on("init", "--help",
                "init task.") { puts "INIT"; exit }
        opts.parse!(arguments)
      end

      path = options[:path]

      # do stuff
      stdout.puts "go fuck yourself"
    end
  end
end
