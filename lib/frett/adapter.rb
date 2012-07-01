require 'ferret'

class Frett::Adapter

  def initialize(options = {})
    new_index = !Frett::Config.consider_mtime || options[:clean]
    unless File.directory?(Frett::Config.index_path)
      new_index = true
      Dir.mkdir(Frett::Config.index_path)
    end
    index = Ferret::Index::Index.new(:path => Frett::Config.index_path, :create => new_index)
    if new_index
      File.open(Frett::Config.mtime_path, "w") {}
      past = Time.local(1970,"jan",1,0,0,0)
      File.utime(past, past, Frett::Config.mtime_path)
      index.field_infos.add_field :file,    :store => :yes, :index => :untokenized, :term_vector => :no
      index.field_infos.add_field :content, :store => :yes, :index => :yes
      index.field_infos.add_field :line,    :store => :yes, :index => :yes,         :term_vector => :no
    end
    index.close
  end

  def writer_index(update = false, options = {}, &block)
    index = Ferret::Index::Index.new(:path => Frett::Config.index_path)
    worker = Proc.new(&block)
    worker.call(index)
  ensure
    index.optimize
    index.close
    File.utime(Time.now, Time.now, Frett::Config.mtime_path)
  end

  def reader_index(&block)
    index = Ferret::Index::Index.new(:path => Frett::Config.index_path)
    worker = Proc.new(&block)
    worker.call(index)
  ensure
    index.close
  end

end
