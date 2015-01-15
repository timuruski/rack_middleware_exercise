require_relative 'test_helper'
require_relative '../lib/jsonp'

class TestJsonP < Minitest::Test
  TEST_APP = Proc.new do |env|
    [200, {'Content-type' => 'application/json'}, ['{"user": "alice"}']]
  end

  def setup
    @subject = JsonP.new(TEST_APP)
  end

  # When callback is provided and response content-type is JSON
  def test_happy_path
    env = Rack::MockRequest.env_for('/users/123', params: {'callback' => 'parseUser'})
    _, _, body = @subject.call(env)

    expected_body = 'parseUser({"user": "alice"});'
    assert_equal body, expected_body
  end

  # When callback is not provided, it does nothing
  # When response content-type is not JSON, it does nothing
end
