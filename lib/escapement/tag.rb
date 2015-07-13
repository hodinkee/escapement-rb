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
        attributes: Hash[filtered_attributes.map { |k, v| [k, v.value] }]
      }

      process_children
    end

    private

    def node_to_type
      case node.name
      when 'p' then 'paragraph'
      when 'a' then 'link'
      when 'i', 'em' then 'italic'
      when 'u' then 'underline'
      when 'strong', 'b' then 'bold'
      when 'abbr' then 'abbreviation'
      when 'q' then 'quote'
      when 'pre' then 'preformatted'
      when 'img' then 'image'
      when 'li' then 'list_item'
      when /h\d/ then 'header'
      else node.name
      end
    end

    def filtered_attributes
      method_name = Attributes.respond_to?(node.name) ? node.name : :default
      node.attributes.select(&Attributes.method(method_name))
    end
  end
end
