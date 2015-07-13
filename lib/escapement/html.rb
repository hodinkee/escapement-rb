module Escapement
  class HTML
    attr_reader :doc, :blocks, :results

    def initialize(html)
      @doc = Nokogiri::HTML(html)
      @blocks = []
      @results = nil
    end

    def extract!
      @blocks = doc.css('body').children.map { |child| Block.new(child).tap(&:process!) }
      @results = @blocks.map(&:result)
    end
  end
end
