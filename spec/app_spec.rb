# frozen_string_literal: true

# For reference:
# https://github.com/citizensadvice/mokta/blob/master/spec/features/app_spec.rb
# http://sinatrarb.com/testing.html
# get '/path', params={}, rack_env={}

describe "liveness check" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "should get /" do
    get "/" do
      get "/"
      expect(last_response).to be_ok
      expect(last_response.body).to eq "Image Resizer service is running"
    end
  end
end
