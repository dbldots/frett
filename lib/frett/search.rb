class Frett::Search

  def initialize(options = {})
    @options = Frett::Config.search.merge(:default_field => :content).
      merge(options)
  end

  def search(needle)
    results = []
    adapter.read do |index|
      index.search_each(build_query(needle), :limit => Frett::Config.num_docs) do |doc_id, score|
        results.push result_line(index[doc_id])
      end
    end

    puts results.size == 1 ? "1 match" : "#{results.size} matches"
    results.each do |result|
      puts result
    end
  end

  private

  def result_line(doc)
    file = doc[:file].gsub!(File.join(Frett::Config.working_dir,"/"), '')
    content = ( doc[:content].length > 80 ) ? ( doc[:content][0..77] + "..." ) : doc[:content]
    "#{file}:#{doc[:line]} #{content}"
  end

  def adapter
    @adapter ||= Frett::Adapter.new
  end

  def build_query(needle)
    needle = escape(needle) if @options[:escape]
    needle = "*#{needle}*"  if @options[:use_wildcard]
    Ferret::QueryParser.new(:default_field => @options[:default_field], :or_default => @options[:use_or]).
      parse(needle.downcase)
  end

  def escape(needle)
    [' ', '\\','&','(',')','[',']','{','}','!','"','~','^','|','<','>','=','*','?','+','-'].each do |char|
      needle.gsub!(char, "\\#{char}")
    end
    needle
  end
end
