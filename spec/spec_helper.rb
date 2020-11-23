# frozen_string_literal: true

require "byebug"
require "capybara/rspec"
require "rack/test"
require "sinatra"
require_relative "../app"

Capybara.app = Sinatra::Application

def app
  Sinatra::Application
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
