module RequestHelpers
  def parse_json(json) = JSON.parse(json).deep_symbolize_keys
end

RSpec.configure { |config| config.include RequestHelpers }
