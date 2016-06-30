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
      preprocess!

      @blocks = doc.css('body').children.map { |child| Block.new(child).tap(&:process!) }
      @results = @blocks.reject { |b| b.result.nil? }.map(&:result)
    end

    private

    # Run a preprocess pass on the HTML in order to format certain entities
    # before we start recording entity positions.
    def preprocess!(node = @doc)
      node.children.each do |child|
        preprocess_node(child)
        preprocess!(child)
      end
    end

    def preprocess_node(node)
      if node.name == 'br'
        node.replace Nokogiri::XML::Text.new("\n", @doc)
      end
    end
  end
end
