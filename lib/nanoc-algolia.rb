# Derived from https://github.com/PascalW/jekyll_indextank
require 'algoliasearch'
require 'nokogiri'

class SearchFilter < Nanoc::Filter
  identifier :algolia
  type :text

  def initialize(hash = {})
    super

    raise ArgumentError.new 'Missing algolia:application_id' unless @config[:algolia][:application_id]
    raise ArgumentError.new 'Missing algolia:api_key' unless @config[:algolia][:api_key]
    raise ArgumentError.new 'Missing algolia:index' unless @config[:algolia][:index]

    @last_indexed_file = '.nanoc_algolia'

    load_last_timestamp

    Algolia.init application_id: @config[:algolia][:application_id],
                 api_key: @config[:algolia][:api_key]

    @index = Algolia::Index.new(@config[:algolia][:index])
  end

  # Index all pages
  # The main content from each page is extracted and indexed at algolia
  # The id of each document will be the absolute url to the resource without domain name
  def run(content, params={})
    # only process item that are changed since last regeneration
    if (!@last_indexed.nil? && @last_indexed > item.mtime)
      return content
    end

    puts "Indexing page #{@item.identifier}"

    page_text = extract_text(content)

    @index.save_object(
      {
        text: => page_text,
        title: => @item[:title] || item.identifier
      }, item.identifer)
    puts 'Indexed ' << item.identifier

    @last_indexed = Time.now
    write_last_indexed

    content
  end

  def extract_text(content)
    doc = Nokogiri::HTML(content)
    doc.xpath('//*/text()').to_a.join(" ").gsub("\r"," ").gsub("\n"," ")
  end

  def write_last_indexed
    begin
      File.open(@last_indexed_file, 'w') {|f| Marshal.dump(@last_indexed, f)}
    rescue
      puts 'WARNING: cannot write indexed timestamps file.'
    end
  end

  def load_last_timestamp
    begin
      @last_indexed = File.open(@last_indexed_file, "rb") {|f| Marshal.load(f)}
    rescue
      @last_indexed = nil
    end
  end
end
