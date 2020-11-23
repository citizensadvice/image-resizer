# frozen_string_literal: true

describe "image resizer app" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe "get /" do
    it "returns a message that confirms the service is running" do
      get "/" do
        get "/"
        expect(last_response).to be_ok
        expect(last_response.body).to eq "Image Resizer service is running"
      end
    end
  end

  describe "post /image" do
    context "without params" do
      it "returns status code 400" do
        post "/image"
        expect(last_response.status).to eq 400
      end
    end

    xcontext "with image file .png" do
      let!(:image) { File.open("spec/fixtures/image/test-png.png") }
      let!(:mime_type) { "image/png" }

      it "returns a resized image" do
        post "/image", image: image, mime_type: mime_type
        expect(last_response.status).to eq 400
      end
    end
  end
end
