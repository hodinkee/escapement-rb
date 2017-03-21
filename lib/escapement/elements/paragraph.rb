module Escapement
  module Element
    class Paragraph < Base
      def self.should_handle?(node)
        ['p', 'li'].include? node.name
      end

      def process!
        return if node_is_blank?

        process_children

        @result = {
          type: node_to_type,
          html_tag: node.name,
          text: node.text,
          entities: @entities
        }
      end
    end
  end
end
