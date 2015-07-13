module Escapement
  class HTML
    attr_reader :doc, :tag, :results

    def initialize(html, tag = 'p')
      @doc = Nokogiri::HTML(html)
      @tag = tag
      @results = nil
    end

    def extract
      blocks = doc.css(tag).map { |child| Block.new(child).tap(&:process!) }
      @results = blocks.map(&:result)
    end
  end
end
