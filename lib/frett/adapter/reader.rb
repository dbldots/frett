module Frett
  module Adapter
    class Reader < Base

      def search(needle, options = {})
        results = connection[:files_rt].search(needle, options.merge(:limit => LIMIT))[:records]
        results || []
      end

    end
  end
end
