# frozen_string_literal: true

ENV["APP_ENV"] = "test"

require "image_processing/mini_magick"
require "rack/test"
require "sinatra"
require "debug"
require_relative "../app"

def app
  Sinatra::Application
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
