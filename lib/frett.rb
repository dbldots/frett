Dir.glob(File.join(File.expand_path(File.dirname(__FILE__)), "frett/**/*")).each do |file|
  require file unless File.directory?(file)
end

require 'debugger'
