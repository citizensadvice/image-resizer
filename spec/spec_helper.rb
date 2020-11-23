# frozen_string_literal: true

require "rack/test"
require_relative "../app"

def app
  Sinatra::Application
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
