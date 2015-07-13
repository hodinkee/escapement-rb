module Escapement
  module Attributes extend self
    def a(key, value)
      true if key == "href"
    end
  end
end
