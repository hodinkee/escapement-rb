module Escapement
  module Traversal
    def process_children
      node.children.each do |child|
        if child.text?
          @current_position += child.content.length
        else
          tag = Escapement::Tag.new(child, @current_position)
          tag.process

          @current_position += child.content.length
          @entities.concat tag.entities
        end
      end
    end
  end
end
