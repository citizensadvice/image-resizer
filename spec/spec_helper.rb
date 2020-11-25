# frozen_string_literal: true

require "image_processing/mini_magick"
require "rack/test"
require "sinatra"
require_relative "../app"

def app
  Sinatra::Application
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
