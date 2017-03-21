module Escapement
  module PrettyNames
    def node_to_type
      case node.name
      when 'p' then 'paragraph'
      when 'ul' then 'unordered_list'
      when 'ol' then 'ordered_list'
      when 'a' then 'link'
      when 'i', 'em' then 'italic'
      when 'u' then 'underline'
      when 'strong', 'b' then 'bold'
      when 'abbr' then 'abbreviation'
      when 'q' then 'quote'
      when 'pre' then 'preformatted'
      when 'img' then 'image'
      when 'li' then 'list_item'
      when 'sup' then 'superscript'
      when 'sub' then 'subscript'
      when /h\d/ then 'header'
      else node.name
      end
    end
  end
end
