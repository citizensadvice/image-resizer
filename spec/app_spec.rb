# frozen_string_literal: true

require_relative "../lib/version"

describe "image resizer app", type: :feature do
  let(:image_file) { Rack::Test::UploadedFile.new("spec/fixtures/image_files/#{test_image_file_name}") }
  let(:test_image_file_name) { "test-png-small-314x580px.png" }
  let(:resized_image_path) do
    path = Tempfile.new.path
    File.write(path, last_response.body, binmode: true)
    path
  end
  let(:resized_image) { MiniMagick::Image.new(resized_image_path) }

  describe "base url liveness check" do
    it "returns status" do
      get "/"
      expect(last_response.status).to eq 200
      expect(last_response.body).to eq "Image Resizer service is running"
    end
  end

  describe "get /version" do
    it "returns the version" do
      get "/version"
      expect(last_response.status).to eq 200
      expect(last_response.body).to eq VERSION
    end
  end

  describe "post /image" do
    context "with missing image" do
      it "returns 400 status" do
        post "/image"

        expect(last_response.status).to eq 400
        expect(last_response.body).to eq "no image file was provided"
      end
    end

    context "with invalid width" do
      it "returns 400 status" do
        post "/image", image_file:, width: 0

        expect(last_response.status).to eq 400
        expect(last_response.body).to eq "invalid width"
      end
    end

    context "with invalid height" do
      it "returns 400 status" do
        post "/image", image_file:, height: 0

        expect(last_response.status).to eq 400
        expect(last_response.body).to eq "invalid height"
      end
    end

    context "with an unsupported image type" do
      let(:test_image_file_name) { "test_csv.csv" }

      it "returns 500 status" do
        post("/image", image_file:)

        expect(last_response.status).to eq 500
        expect(last_response.body).to include "magick convert"
      end
    end

    context "with a .png image that has larger dimensions than 800px" do
      let(:test_image_file_name) { "test-png-1102x1287px.png" }

      it "returns the PNG image resized to maximum dimensions of 800px" do
        post("/image", image_file:)

        expect(last_response.status).to eq 200
        expect(resized_image.type).to eq "PNG"
        expect(resized_image.dimensions).to eq [685, 800]
      end
    end

    context "with a .png image that has smaller dimensions than 800px" do
      let(:test_image_file_name) { "test-png-small-314x580px.png" }

      it "returns the PNG image at its original size" do
        post("/image", image_file:)

        expect(last_response.status).to eq 200
        expect(resized_image.type).to eq "PNG"
        expect(resized_image.dimensions).to eq [314, 580]
      end
    end

    context "with a .jpg image that has larger dimensions than 800px" do
      let(:test_image_file_name) { "test-jpg-1102x1287px.jpg" }

      it "returns the JPEG image resized to maximum dimensions of 800px" do
        post("/image", image_file:)

        expect(last_response.status).to eq 200
        expect(resized_image.type).to eq "JPEG"
        expect(resized_image.dimensions).to eq [685, 800]
      end
    end

    context "with a .gif image that has larger dimensions than 800px" do
      let(:test_image_file_name) { "test-gif-1102x1287px.gif" }

      it "returns the GIF image resized to maximum dimensions of 800px" do
        post("/image", image_file:)

        expect(last_response.status).to eq 200
        expect(resized_image.type).to eq "GIF"
        expect(resized_image.dimensions).to eq [685, 800]
      end
    end

    context "with a .tif image that has larger dimensions than 800px" do
      let(:test_image_file_name) { "test-bad-tif-800x1000px.tif" }

      it "returns the image converted to PNG and resized to maximum dimensions of 800px" do
        post("/image", image_file:)

        expect(last_response.status).to eq 200
        expect(resized_image.type).to eq "PNG"
        expect(resized_image.dimensions).to eq [640, 800]
      end
    end

    context "with a .bmp image" do
      let(:test_image_file_name) { "test-bmp.bmp" }

      it "returns the image converted to PNG and resized to maximum dimensions of 800px" do
        post("/image", image_file:)

        expect(last_response.status).to eq 200
        expect(resized_image.type).to eq "PNG"
        expect(resized_image.dimensions).to eq [800, 533]
      end
    end

    context "with a .webp image" do
      let(:test_image_file_name) { "test-webp.webp" }

      it "returns the image converted to PNG and resized to maximum dimensions of 800px" do
        post("/image", image_file:)

        expect(last_response.status).to eq 200
        expect(resized_image.type).to eq "PNG"
        expect(resized_image.dimensions).to eq [320, 214]
      end
    end

    context "with a custom width" do
      let(:test_image_file_name) { "test-png-1102x1287px.png" }

      it "resizes to the custom width" do
        post "/image", image_file:, width: 200

        expect(last_response.status).to eq 200
        expect(resized_image.type).to eq "PNG"
        expect(resized_image.dimensions).to eq [200, 234]
      end
    end

    context "with a custom height" do
      let(:test_image_file_name) { "test-png-1102x1287px.png" }

      it "resizes to the custom height" do
        post "/image", image_file:, height: 200

        expect(last_response.status).to eq 200
        expect(resized_image.type).to eq "PNG"
        expect(resized_image.dimensions).to eq [171, 200]
      end
    end

    context "with a svg image" do
      let(:test_image_file_name) { "test-svg.svg" }

      it "optimises the image" do
        post("/image", image_file:)

        expect(`file --brief --mime-type #{resized_image_path}`.chomp).to eq "image/svg+xml"
        expect(last_response.body.size.to_f / File.open(image_file).size).to be_between(0.6, 0.8)
      end
    end
  end
end
