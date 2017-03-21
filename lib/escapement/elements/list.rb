module Escapement
  module Element
    module List
      def process!
        return if node_is_blank?

        @entities = node.children.map { |child|
          next if child.text?
          Element.factory(child).tap(&:process!)
        }.compact

        @result = {
          type: node_to_type,
          html_tag: node.name,
          children: @entities.map(&:result)
        }
      end
    end
  end
end
