require "image_processing/mini_magick"

class ImageResizeService
  FIRST_PAGE = 0
  IMAGE_TYPES_REQUIRING_CONVERSION = [
    "image/tiff"
  ].freeze
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

  # https://www.imagemagick.org/discourse-server/viewtopic.php?t=33626
  def copy_tiff(file)
    copied = Tempfile.new(["copy", ".tif"], binmode: true)
    system("tiffcp #{file.path} #{copied.path}", exception: true, err: File::NULL)
    copied
  end

  def resize_image
    file = @file
    file = copy_tiff(@file) if @mime_type == "image/tiff"
    pipeline = ImageProcessing::MiniMagick.source(file)
    pipeline = pipeline.convert("png").loader(page: FIRST_PAGE) if IMAGE_TYPES_REQUIRING_CONVERSION.include?(@mime_type)
    pipeline.resize_to_limit!(RESIZE_WIDTH, RESIZE_HEIGHT)
  end
end
