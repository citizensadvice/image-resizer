require 'sinatra'
require './image_resizer.rb'

set :show_exceptions, :after_handler

get '/' do
  status 200
  body 'Hello world!'
end

get '/test/png' do
	image_file = File.open('./test_images/test-png-1102x1287px.png')
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
	mime_type = request.content_type
	image_file = request.body.read
	
	resized_image = ImageResizeService.call(image_file, mime_type)
	
	status 200
	body resized_image
end
