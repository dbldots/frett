require 'oedipus'
require 'open4'
require 'zlib'

module Frett
  module Adapter
    class Base
      LIMIT = 10000

      def self.connection
        @connection ||= Oedipus::Connection.new(host: "127.0.0.1", port: 9399, verify: false)
      end

      def connection
        self.class.connection
      end

    end
  end
end
