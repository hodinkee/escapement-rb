module Escapement
  class Block
    include Traversal

    attr_reader :node, :entities, :result

    def initialize(node)
      @node = node
      @entities = []
      @result = nil
      @current_position = 0
    end

    def process!
      process_children

      @result = {
        text: node.text,
        entities: @entities
      }
    end
  end
end
