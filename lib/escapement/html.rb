module Escapement
  # Wrapper around the entire document, which contains an array of
  # results. Each result is the text value and entities for a single
  # element.
  class HTML
    attr_reader :doc, :elements, :results

    def initialize(html)
      @doc = Nokogiri::HTML(html)
      @elements = []
      @results = nil
    end

    # Extracts all of the entities for each element.
    def extract!
      preprocess!

      @elements = doc.css('body').children.map { |child| Element.factory(child) }.compact
      @results = @elements.each(&:process!).reject { |e| e.result.nil? }.map(&:result)
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
