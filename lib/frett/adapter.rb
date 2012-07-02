require 'ferret'

class Frett::Adapter

  def writer_index(update = false, options = {}, &block)
    new_index = !update && !Frett::Config.consider_mtime
    unless File.directory?(Frett::Config.index_path)
      new_index = true
      Dir.mkdir(Frett::Config.index_path)
      File.open(Frett::Config.mtime_path, "w") {}
      past = Time.local(1970,"jan",1,0,0,0)
      File.utime(past, past, Frett::Config.mtime_path)
    end
    worker = Proc.new(&block)
    options.merge!({ :path => Frett::Config.index_path, :create => new_index })
    index = Ferret::Index::Index.new(options)
    if new_index
      index.field_infos.add_field :file,        :store => :yes, :index => :untokenized, :term_vector => :no
      index.field_infos.add_field :content,     :store => :yes, :index => :yes
      index.field_infos.add_field :line,        :store => :yes, :index => :yes,         :term_vector => :no
      #index.field_infos.add_field :indexed_at,  :store => :yes, :index => :yes,         :term_vector => :no
    end

    worker.call(index)
  ensure
    if index
      index.optimize
      index.close
      File.utime(Time.now, Time.now, Frett::Config.mtime_path)
    end
  end

  def reader_index(&block)
    worker = Proc.new(&block)
    index = Ferret::Index::Index.new(:path => Frett::Config.index_path)
    worker.call(index)
  ensure
    index.close
  end

end
