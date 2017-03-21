module Escapement
  module Element
    class OrderedList < Base
      include List

      def self.should_handle?(node)
        node.name == 'ol'
      end
    end
  end
end
