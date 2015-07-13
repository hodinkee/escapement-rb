module Escapement
  class Tag
    include Traversal

    attr_reader :node, :entities

    def initialize(node, start_position)
      @node = node
      @start_position = @current_position = start_position
      @entities = []
    end

    def process
      @entities << {
        type: node_to_type,
        html_tag: node.name,
        position: [@current_position, @current_position + node.text.length],
        attributes: Hash[node.attributes.map { |k, v| [k, v.value] }]
      }

      process_children
    end

    private

    def node_to_type
      case node.name
      when 'p' then 'paragraph'
      when 'a' then 'link'
      when 'i' then 'italic'
      when 'strong', 'b' then 'bold'
      else node.name
      end
    end
  end
end
