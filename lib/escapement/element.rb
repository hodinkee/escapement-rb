require 'escapement/elements/base'
require 'escapement/elements/paragraph'
require 'escapement/elements/list'
require 'escapement/elements/ordered_list'
require 'escapement/elements/unordered_list'

module Escapement
  # An element represents a root-level element in the given
  # HTML string. Each paragraph has it's own text value and
  # array of entities.
  module Element
    extend self

    NODE_TYPES = [
      Element::Paragraph,
      Element::OrderedList,
      Element::UnorderedList
    ].freeze

    def factory(node)
      NODE_TYPES.each do |type|
        if type.should_handle?(node)
          return type.new(node)
        end
      end
    end
  end
end
