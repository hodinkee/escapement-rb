module Escapement
  module Element
    class UnorderedList < Base
      include List

      def self.should_handle?(node)
        node.name == 'ul'
      end
    end
  end
end
