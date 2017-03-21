module Escapement
  module Traversal
    # Processes all child nodes of the current node. As the recursion unwinds, we
    # update the entities array such that we're left with a full result set at
    # the root, which is the Element object.
    def process_children
      node.children.each do |child|
        if child.text?
          # If the child node is a text node, we know there are no entities. We simply
          # increase the current position and continue.
          @current_position += child.content.length
        else
          # The node is not a text node, so it must be an entity of some kind. Continue
          # the recursion.
          tag = Escapement::Tag.new(child, @current_position)
          tag.process

          @current_position += child.content.length
          @entities.concat tag.entities
        end
      end
    end
  end
end
