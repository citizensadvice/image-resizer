# frozen_string_literal: true

# This uses the image_processing gem, which can use vips or imagemagick to process images
# https://github.com/janko/image_processing

require "image_processing/mini_magick"

class ImageResizeService
  FIRST_PAGE = 0
  RESIZE_WIDTH = 800
  RESIZE_HEIGHT = 800

  def self.call(file, mime_type)
    new(file, mime_type).call
  end

  def initialize(file, mime_type)
    @file = file
    @mime_type = mime_type
  end

  def call
    resize_image
  end

  private

  def resize_image
    file = @file
    file = copy_tiff(@file) if requires_conversion?
    pipeline = ImageProcessing::MiniMagick.source(file)
    pipeline = pipeline.convert("png").loader(page: FIRST_PAGE) if requires_conversion?
    pipeline.resize_to_limit!(RESIZE_WIDTH, RESIZE_HEIGHT)
  end

  def requires_conversion?
    @requires_conversion ||= (@mime_type == "image/tiff")
  end

  # https://www.imagemagick.org/discourse-server/viewtopic.php?t=33626
  def copy_tiff(file)
    copied = Tempfile.new(["copy", ".tif"], binmode: true)
    system("tiffcp #{file.path} #{copied.path}", exception: true, err: File::NULL)
    copied
  end
end
