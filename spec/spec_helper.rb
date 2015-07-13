$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'escapement'

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.disable_monkey_patching!
  
  config.order = :random
  Kernel.srand config.seed
end
