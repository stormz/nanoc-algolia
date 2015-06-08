# Derived from https://github.com/PascalW/jekyll_indextank
require 'algoliasearch'
require 'nokogiri'

class SearchFilter < Nanoc::Filter
  identifier :algolia
  type :text

  def initialize(hash = {})
    super

    raise ArgumentError.new 'Missing algolia config' unless @config[:algolia]
    raise ArgumentError.new 'Missing algolia:application_id' unless @config[:algolia][:application_id]
    raise ArgumentError.new 'Missing algolia:api_key' unless @config[:algolia][:api_key]
    raise ArgumentError.new 'Missing algolia:index' unless @config[:algolia][:index]

    Algolia.init application_id: @config[:algolia][:application_id],
                 api_key: @config[:algolia][:api_key]

    @index = Algolia::Index.new(@config[:algolia][:index])
  end

  # Index all pages
  # The main content from each page is extracted and indexed at algolia
  # The id of each document will be the absolute url to the resource without domain name
  def run(content, params={})
    puts "Indexing page #{@item.identifier}"

    page_text = extract_text(content)

    @index.save_object(
      {
        text: page_text,
        title: @item[:title] || item.identifier
      }, item.identifier)
    puts 'Indexed ' << item.identifier

    content
  end

  def extract_text(content)
    doc = Nokogiri::HTML(content)
    doc.xpath('//*/text()').to_a.join(" ").gsub("\r"," ").gsub("\n"," ")
  end
end
