require 'listen'

module Frett
  class Listener

    def initialize
      indexer = Frett::Indexer.new
      ::Listen.to(Frett::Config.working_dir) do |modified, added, removed|
        modified.each do |filename|
          indexer.update_file(filename)
        end

        added.each do |filename|
          indexer.update_file(filename)
        end

        removed.each do |filename|
          indexer.remove_file(filename)
        end
      end
    end
  end
end
