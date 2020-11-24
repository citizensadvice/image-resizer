# frozen_string_literal: true

describe "image resizer app", type: :feature do
  describe "base url liveness check" do
    it "returns a message that confirms the service is running" do
      visit "/"
      expect(page.status_code).to eq 200
      expect(page.body).to eq "Image Resizer service is running"
    end
  end

  describe "post /image" do
    context "without params" do
      it "returns status code 400" do
        response = post "/image"
        expect(response.status).to eq 400
      end
    end

    context "with image file .png" do
      let(:image_file) { Rack::Test::UploadedFile.new("spec/fixtures/image_files/test-png-1102x1287px.png", "image/png") }
      let(:mime_type) { "image/png" }

      it "returns status code 200" do
        response = post "/image", image_file: image_file, mime_type: mime_type
        expect(response.status).to eq 200
      end

      xit "resizes large images down to dimensions with a maximum of 800px" do
        # response = post "/image", image_file: image_file, mime_type: mime_type
        # https://github.com/janko/image_processing/blob/master/doc/minimagick.md 
        # resized_image = MiniMagick::Image.new(response.body)
        # expect(resized_image.dimensions).to eq [800, 800]
      end
    end
  end
end
