# frozen_string_literal: true

require_relative "lib/image_resize_service"
require "sinatra"
require "newrelic_rpm"
require "debug" if Sinatra::Base.development?

get "/" do
  status 200
  body "Image Resizer service is running"
end

post "/image" do
  image_file = params[:image_file]&.[](:tempfile)
  halt 400, "no image file was provided" unless image_file.is_a?(Tempfile)

  options = { width:, height: }.compact
  resized_image = ImageResizeService.call(image_file, **options)
  status 200
  body resized_image
end

error MiniMagick::Error do
  NewRelic::Agent.notice_error(env["sinatra.error"])
  env["sinatra.error"].message
end

def width
  value = params[:width]&.to_i
  halt 400, "invalid width" if value && value <= 0

  value
end

def height
  value = params[:height]&.to_i
  halt 400, "invalid height" if value && value <= 0

  value
end
