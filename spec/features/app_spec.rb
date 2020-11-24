# frozen_string_literal: true

# MiniMagick is part of the the image_processing gem
# https://github.com/janko/image_processing/blob/master/doc/minimagick.md
# This can be used to find out image size dimensions

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
      let(:temp_image_file_path) { Tempfile.new.path  }

      it "returns status code 200" do
        response = post "/image", image_file: image_file, mime_type: mime_type
        expect(response.status).to eq 200
      end

      it "resizes large images down to dimensions with a maximum of 800px" do
        response = post "/image", image_file: image_file, mime_type: mime_type
        File.open(temp_image_file_path,'w') { |f| f.write response.body }
        resized_image = MiniMagick::Image.new(temp_image_file_path)

        expect(resized_image.dimensions).to eq [685, 800]
      end
    end
  end
end
