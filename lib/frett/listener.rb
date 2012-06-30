require 'listen'

module Frett
  class Listener

    def initialize
      indexer = Frett::Indexer.new
      ::Listen.to(Frett::Config.working_dir) do |modified, added, removed|
        #puts "modified: #{modified.inspect}"
        modified.each do |filename|
          indexer.update_file(filename)
        end

        #puts "added: #{added.inspect}"
        added.each do |filename|
          indexer.update_file(filename)
        end

        #puts "removed: #{removed.inspect}"
        removed.each do |filename|
          indexer.remove_file(filename)
        end
      end
    end
  end
end
