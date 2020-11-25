# frozen_string_literal: true

describe "image resizer app", type: :feature do
  describe "base url liveness check" do
    it "returns status code 200" do
      response = get "/"
      expect(response.status).to eq 200
    end

    it "returns a message that confirms the service is running" do
      response = get "/"
      expect(response.body).to eq "Image Resizer service is running"
    end
  end

  describe "post /image" do
    context "without params" do
      it "returns status code 400" do
        response = post "/image"
        expect(response.status).to eq 400
      end
    end

    context "with valid params :image_file and :mime_type" do
      let(:test_images_root_path) { "spec/fixtures/image_files/" }
      let(:test_image_file_name) { "" }
      let(:mime_type) { "" }
      let(:image_file) { Rack::Test::UploadedFile.new(test_images_root_path + test_image_file_name, mime_type) }
      let(:temp_image_file_path) { Tempfile.new.path }

      context "with a .png image that has smaller dimensions than 800px" do
        let(:test_image_file_name) { "test-png-small-314x580px.png" }
        let(:mime_type) { "image/png" }

        it "returns status code 200" do
          response = post "/image", image_file: image_file, mime_type: mime_type
          expect(response.status).to eq 200
        end

        it "returns the image at its original size" do
          response = post "/image", image_file: image_file, mime_type: mime_type
          File.open(temp_image_file_path, "w") { |f| f.write response.body }
          resized_image = Vips::Image.new_from_file(temp_image_file_path)

          expect(resized_image.size).to eq [314, 580]
        end
      end

      context "with a .png image that has larger dimensions than 800px" do
        let(:test_image_file_name) { "test-png-1102x1287px.png" }
        let(:mime_type) { "image/png" }

        it "returns status code 200" do
          response = post "/image", image_file: image_file, mime_type: mime_type
          expect(response.status).to eq 200
        end

        it "returns the image resized to maximum dimensions of 800px" do
          response = post "/image", image_file: image_file, mime_type: mime_type
          File.open(temp_image_file_path, "w") { |f| f.write response.body }
          resized_image = Vips::Image.new_from_file(temp_image_file_path)

          expect(resized_image.size).to eq [685, 800]
        end
      end

      context "with a .jpg image that has larger dimensions than 800px" do
        let(:test_image_file_name) { "test-jpg-1102x1287px.jpg" }
        let(:mime_type) { "image/jpeg" }

        it "returns status code 200" do
          response = post "/image", image_file: image_file, mime_type: mime_type
          expect(response.status).to eq 200
        end

        it "returns the image resized to maximum dimensions of 800px" do
          response = post "/image", image_file: image_file, mime_type: mime_type
          File.open(temp_image_file_path, "w") { |f| f.write response.body }
          resized_image = Vips::Image.new_from_file(temp_image_file_path)

          expect(resized_image.size).to eq [685, 800]
        end
      end

      context "with a .gif image that has larger dimensions than 800px" do
        let(:test_image_file_name) { "test-gif-1102x1287px.gif" }
        let(:mime_type) { "image/gif" }

        it "returns status code 200" do
          response = post "/image", image_file: image_file, mime_type: mime_type
          expect(response.status).to eq 200
        end

        it "returns the image resized to maximum dimensions of 800px" do
          response = post "/image", image_file: image_file, mime_type: mime_type
          File.open(temp_image_file_path, "w") { |f| f.write response.body }
          resized_image = Vips::Image.new_from_file(temp_image_file_path)

          expect(resized_image.size).to eq [685, 800]
        end
      end

      context "with a .tif image that has larger dimensions than 800px" do
        let(:test_image_file_name) { "test-bad-tif-800x1000px.tif" }
        let(:mime_type) { "image/tiff" }

        it "returns status code 200" do
          response = post "/image", image_file: image_file, mime_type: mime_type
          expect(response.status).to eq 200
        end

        it "returns the image resized to maximum dimensions of 800px" do
          response = post "/image", image_file: image_file, mime_type: mime_type
          File.open(temp_image_file_path, "w") { |f| f.write response.body }
          resized_image = Vips::Image.new_from_file(temp_image_file_path)

          expect(resized_image.size).to eq [640, 800]
        end
      end
    end
  end
end
