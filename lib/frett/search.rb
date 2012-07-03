class Frett::Search

  def initialize(options = {})
    @options = Frett::Config.search.merge(:default_field => :content).
      merge(options)
  end

  def search(needle, path = nil)
    results = []
    adapter.read do |index|
      index.search_each(build_query(needle, path), :limit => Frett::Config.num_docs) do |doc_id, score|
        results.push result(index[doc_id])
      end
    end

    puts ( results.size == 1 ? "1 match" : "#{results.size} matches" ).white
    results.flatten.map { |result_line| puts result_line }
  end

  private

  def result(doc)
    file = doc[:file].gsub!(File.join(Frett::Config.working_dir,"/"), '')
    line = doc[:line]
    content = ( doc[:content].length > 200 ) ? ( doc[:content][0..77] + "..." ) : doc[:content]
    if @options[:vim]
      "#{file}:#{line}:#{content}"
    else
      ["", file.light_yellow, "#{line}: #{content.light_blue}"]
    end
  end

  def adapter
    @adapter ||= Frett::Adapter.new
  end

  def build_query(needle, path)
    needle = escape(needle) if @options[:escape]
    needle = "*#{needle}*"  if @options[:use_wildcard]
    #parsed = Ferret::QueryParser.new(:default_field => @options[:default_field], :or_default => @options[:use_or]).
      #parse(needle.downcase)
    q = "content:#{needle.downcase}" << ( path ? " + file:#{path}*" : "" )
    Ferret::QueryParser.new(:fields => [:content, :file], :tokenized_fields => :content, :or_default => @options[:use_or]).
      parse(q)
  end

  def escape(needle)
    Regexp.escape(needle).gsub(/([:~!<>="])/,'\\\\\1')
  end
end
