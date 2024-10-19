m = Module.new {
  private def subject_response_to_hash
    JSON.parse(subject.to_json).deep_symbolize_keys
  end
}
RSpec.configure do |config|
  config.include(m, type: :request)
end
