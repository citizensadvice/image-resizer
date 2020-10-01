require 'sinatra'
require './image_resizer.rb'

set :show_exceptions, :after_handler

get '/' do
  status 200
  body 'Hello world!'
end

get 'png' do
	image_file = File.open('./test_images/test-png-1102x1287px.png')
	resized_image = ImageResizeService.call(image_file)
	status 200
	body resized_image
end

get 'tiff' do
	image_file = File.open('./test_images/test-png-1102x1287px.png')
	resized_image = ImageResizeService.call(image_file)
	status 200
	body resized_image
end

get '/resize_image' do
	if params.key?(:image)
		resized_image = ImageResizeService.call(params[:image])
		status 200
		body resized_image
	else
		status 400
		body 'Bad request or missing param for image'
	end
end
