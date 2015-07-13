module Escapement
  module Attributes extend self
    def a(key, value)
      true if key == "href"
    end

    def img(key, value)
      true if key == "src"
    end
  end
end
