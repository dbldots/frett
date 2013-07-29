module Frett
  module Adapter
    class Writer < Base

      class << self
        def data_dir
          Frett::Config.instance.data_dir
        end

        def write_sphinx_config
          File.open("#{data_dir}/sphinx.conf", "w") do |f|
            f << sphinx_conf
          end
        end

        def stop_sphinx
          `#{sphinx_args("--stopwait").join(' ')}`
        end

        def start_sphinx
          err_out = ''
          status = Open4::popen4(*sphinx_args) do |pid, stdin, stdout, stderr|
              err_out = stdout.read.strip
            end

          if status.exitstatus == 0
            true
          elsif err_out.include?("failed to lock")
            # already running
            true
          else
            false
          end
        end

        def sphinx_args(additional_args = nil)
          [searchd, "-c", "#{data_dir}/sphinx.conf"] + Array(additional_args)
        end

        def searchd
          ENV["SEARCHD"] || `which searchd`.strip
        end

        def sphinx_conf
          <<-CONF.strip.gsub(/^ {4}/, "")
          index files_rt
          {
            type = rt
            path = #{data_dir}/files_rt

            rt_field       = content
            rt_attr_string = abstract

            rt_attr_uint   = line
            rt_attr_string = filename
            rt_attr_uint   = filename_hash

            charset_type = utf-8
            charset_table = 0..9, A..Z->a..z, _, -, @, a..z, U+0021..U+0029, U+002B..U+002F, U+003A..U+0040, U+007B, U+007C, U+007D
            enable_star = 1
            min_infix_len = 2
          }

          searchd
          {
            compat_sphinxql_magics = 0

            max_matches  = 2000
            pid_file     = #{data_dir}/searchd.pid
            listen       = #{connection.options[:host]}:#{connection.options[:port]}:mysql41
            workers      = threads
            log          = #{data_dir}/searchd.log
            query_log    = #{data_dir}/searchd.log
            binlog_path  = #{data_dir}
          }
          CONF
        end
      end

      def initialize
        self.class.write_sphinx_config
        self.class.start_sphinx

        @index = last_sphinx_id
      end

      def insert(filename, line, content)
        abstract = ( content.length > 200 ) ? ( content[0..77] + "..." ) : content
        connection[:files_rt].insert(next_id,
          :filename => filename,
          :filename_hash => ::Zlib.crc32(filename),
          :line => line,
          :content => content,
          :abstract => abstract)
      end

      def remove(filename)
        connection.query("SELECT id FROM files_rt WHERE filename_hash = #{::Zlib.crc32(filename)} LIMIT #{LIMIT}").each do |rec|
          connection.query("DELETE FROM files_rt WHERE id = #{rec['id']}")
        end
      end

      def next_id
        @index +=1
      end

      def last_sphinx_id
        result = connection.query("SELECT id FROM files_rt ORDER BY id DESC LIMIT 1")
        (result.first && result.first['id'].to_i) || 0
      end

      def empty_indexes
        connection.query("SHOW TABLES").each do |idx|
          connection.query("SELECT id FROM #{idx['Index']}").each do |hash|
            puts "deleting from #{idx['Index']}"
            connection.execute("DELETE FROM #{idx['Index']} WHERE id = #{hash['id']}")
          end
        end
      end

    end
  end
end
