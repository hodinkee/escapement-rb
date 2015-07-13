module Escapement
  # Wrapper around the entire document, which contains an array of
  # results. Each result is the text value and entities for a single
  # paragraph/block.
  class HTML
    attr_reader :doc, :blocks, :results

    def initialize(html)
      @doc = Nokogiri::HTML(html)
      @blocks = []
      @results = nil
    end

    # Extracts all of the entities for each paragraph/block.
    def extract!
      @blocks = doc.css('body').children.map { |child| Block.new(child).tap(&:process!) }
      @results = @blocks.map(&:result)
    end
  end
end
