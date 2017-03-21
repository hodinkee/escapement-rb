module Escapement
  module Element
    class Base
      include Traversal
      include PrettyNames

      attr_reader :node, :result

      def initialize(node)
        @node = node
        @entities = []
        @result = nil
        @current_position = 0
      end

      def process!
        raise "Override"
      end

      protected

      def node_is_blank?
        # This will match empty strings, strings with spaces, and
        # even strings with unicode non-breakable spaces (which can be
        # produced by &nbsp;)
        node.text =~ /\A[[:space:]]*\z/
      end
    end
  end
end
