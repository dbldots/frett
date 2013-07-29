require 'singleton'
require 'hashery'
require 'fileutils'
require 'yaml'

module Frett

  # class that holds the general configuration settings
  # loads a file .frett.yml if available where you can
  # specify configuration options that may differ from 
  # the defaults
  #
  # Frett::Config is a singleton. access it with
  #   Frett::Config.instance
  class Config
    include ::Singleton
    include ::Hashery

    def initialize
      @options = ::YAML.load(<<-YAML)
        data_dir: .frett
        exclude: "^tags$|log\/|tmp\/"
        service_name: frett_service
      YAML
    end

    # this method has to be called
    def init!(pwd)
      if file = File.exist?(File.join(pwd, '.frett.yml'))
        @options.deep_merge(YAML::load(File.open(file)))
        clear
      end

      unless File.exist?(data_dir = File.join(pwd, options.data_dir))
        FileUtils.mkdir_p(data_dir)
      end
      @pwd = pwd
      clear
    end

    # updates the file that holds the timestamp for the last changes
    def update_mtime
      FileUtils.touch(mtime_path)
      get_mtime
    end

    # get timestamp from last change
    def get_mtime
      File.mtime(mtime_path) rescue Time.at(0)
    end

    def clear_mtime
      File.delete(mtime_path) rescue nil
    end

    # returns the config options as an OpenCascade
    # see http://rubydoc.info/github/rubyworks/hashery/master/Hashery/OpenCascade
    def options
      @cascade ||= OpenCascade[@options.rekey!{ |k| k.to_sym }]
    end

    def pwd
      @pwd || ""
    end

    def data_dir
      File.join(pwd, '.frett')
    end

    def clean_data_dir
      FileUtils.rm_rf(data_dir)
      init!(pwd)
    end

    private

    def mtime_path
      File.join(pwd, options.data_dir, 'mtime')
    end

    def clear
      @cascade = nil
    end

  end
end
