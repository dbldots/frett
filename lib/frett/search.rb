class Frett::Search

  def initialize(options = {})
    @options = options
  end

  def search(needle, path = nil)
    results = adapter.search(needle).map { |rec| result(rec) }

    puts(( results.size == 1 ? "1 match" : "#{results.size} matches" ).white)
    results.flatten.map { |result_line| puts result_line }
  end

  private

  def result(doc)
    file      = doc[:filename].gsub!(File.join(Frett::Config.instance.pwd, "/"), '')
    line      = doc[:line]
    abstract  = doc[:abstract]
    if @options[:vim]
      "#{file}:#{line}:#{abstract}"
    else
      ["", file.light_yellow, "#{line}: #{abstract.light_blue}"]
    end
  end

  def adapter
    @adapter ||= Frett::Adapter::Reader.new
  end
end

