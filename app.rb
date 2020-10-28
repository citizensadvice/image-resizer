# frozen_string_literal: true

require_relative 'lib/image_resizer'
require 'sinatra'

set :show_exceptions, :after_handler

get '/' do
  status 200
  body 'Hello world!'
end

get '/test/png' do
	image_file = File.open('./test_images/test-png.png')
	resized_image = ImageResizeService.call(image_file, 'image/png')
	status 200
	body resized_image
end

get '/test/tif' do
	image_file = File.open('./test_images/test-bad-tif.tif')
	resized_image = ImageResizeService.call(image_file, 'image/tiff')
	status 200
	body resized_image
end

post '/image' do
	mime_type = params[:mime_type]
	image_file = params[:image][:tempfile]
	
	resized_image = ImageResizeService.call(image_file, mime_type)
	
	status 200
	body resized_image
end
