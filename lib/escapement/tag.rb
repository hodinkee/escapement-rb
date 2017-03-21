module Escapement
  # A tag represents an entity that may or may not have child elements.
  # Once we extract the data about this DOM node, we recursively continue
  # the traversal until we reach the leaf text node.
  class Tag
    include Traversal
    include PrettyNames

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
        attributes: Hash[filtered_attributes.map { |k, v| [k, v.value] }]
      }

      process_children
    end

    private

    def filtered_attributes
      method_name = Attributes.respond_to?(node.name) ? node.name : :default
      node.attributes.select(&Attributes.method(method_name))
    end
  end
end
