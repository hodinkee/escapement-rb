module Escapement
  # A block represents a paragraph, which is a root-level element in the
  # given HTML string. Each paragraph has it's own text value and array of entities.
  class Block
    include Traversal

    attr_reader :node, :result

    def initialize(node)
      @node = node
      @entities = []
      @result = nil
      @current_position = 0
    end

    def process!
      # This will match empty strings, strings with spaces, and
      # even strings with unicode non-breakable spaces (which can be
      # produced by &nbsp;)
      return if node.text =~ /\A[[:space:]]*\z/

      process_children

      @result = {
        text: node.text,
        entities: @entities
      }
    end
  end
end
