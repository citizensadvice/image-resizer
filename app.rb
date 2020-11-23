# frozen_string_literal: true

require_relative "lib/image_resizer"
require "sinatra"

set :show_exceptions, :after_handler

get "/" do
  status 200
  body "Image Resizer service is running"
end

post "/image" do
  return ArgumentError.new("expected params to include :mime_type, :image") unless params.keys.include?(:mime_type, :image)

  mime_type = params[:mime_type]
  image_file = params[:image][:tempfile]

  resized_image = ImageResizeService.call(image_file, mime_type)

  status 200
  body resized_image
end
