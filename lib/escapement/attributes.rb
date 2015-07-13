module Escapement
  # These methods filter the allowed attributes on entities in order to cut
  # down on the noise returned with the results.
  module Attributes extend self
    # By default we allow no attributes in order to cut down on noise as
    # much as possible. Attributes can be whitelisted on a per-tag basis.
    def default(key, value)
      false
    end

    def a(key, value)
      true if key == "href"
    end

    def img(key, value)
      true if ['src', 'width', 'height'].include?(key)
    end
  end
end
