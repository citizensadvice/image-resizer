# frozen_string_literal: true

require_relative "lib/image_resize_service"
require "sinatra"

set :show_exceptions, :after_handler

get "/" do
  status 200
  body "Image Resizer service is running"
end

post "/image" do
  error_message = validate_params(params)
  if error_message
    status 400
    return ArgumentError.new(error_message)
  end

  mime_type = params[:mime_type]
  image_file = params[:image_file][:tempfile]

  resized_image = ImageResizeService.call(image_file, mime_type)

  status 200
  body resized_image
end

private

def validate_params(params)
  return "expected params to include :image_file, :mime_type" unless params.key?(:image_file) && params.key?(:mime_type)
  return "expected param :image_file to be a File" unless params[:image_file].is_a?(File) || params[:image_file][:tempfile]
  return "expected param :mime_type to be a String" unless params[:mime_type].is_a?(String)
end
