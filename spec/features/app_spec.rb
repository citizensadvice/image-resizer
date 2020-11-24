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
      let(:test_images_root_path) { "spec/fixtures/image_files/" }
      let(:test_image_file_name) { "test-png-large-1102x1287px.png" }
      let(:mime_type) { "image/png" }
      let(:image_file) { Rack::Test::UploadedFile.new(test_images_root_path + test_image_file_name, mime_type) }
      let(:temp_image_file_path) { Tempfile.new.path  }

      context "with an image that has larger dimensions than 800px" do
        let(:test_image_file_name) { "test-png-large-1102x1287px.png" }
        
        it "returns status code 200" do
          response = post "/image", image_file: image_file, mime_type: mime_type
          expect(response.status).to eq 200
        end

        it "returns the resize image with maximum dimensions of 800px" do
          response = post "/image", image_file: image_file, mime_type: mime_type
          File.open(temp_image_file_path,'w') { |f| f.write response.body }
          resized_image = MiniMagick::Image.new(temp_image_file_path)

          expect(resized_image.dimensions).to eq [685, 800]
        end
      end
    end
  end
end
