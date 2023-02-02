# frozen_string_literal: true

require "image_processing/mini_magick"
require "svg_optimizer"

class ImageResizeService
  RESIZE_WIDTH = 800
  RESIZE_HEIGHT = 800
  KEEP_AS_TYPE = [
    "image/png",
    "image/jpeg",
    "image/gif",
    "image/svg+xml"
  ].freeze

  def self.call(...)
    new(...).call
  end

  def initialize(file, width: RESIZE_WIDTH, height: RESIZE_HEIGHT)
    @file = file
    @width = width
    @height = height
  end

  def call
    return optimise_svg if mime_type == "image/svg+xml"

    resize_image
  end

  private

  def optimise_svg
    temp = Tempfile.new
    @file.rewind
    # https://github.com/fnando/svg_optimizer/issues/9 normalize space
    temp.write SvgOptimizer.optimize(@file.read).gsub(/\s+/, " ")
    temp.rewind
    temp
  end

  def resize_image
    file = @file
    file = copy_tiff(@file) if mime_type == "image/tiff"
    pipeline = ImageProcessing::MiniMagick.source(file)
    pipeline = pipeline.convert("png").loader(page: 0) if requires_conversion?
    pipeline.resize_to_limit!(@width, @height)
  end

  def requires_conversion?
    !KEEP_AS_TYPE.include?(mime_type)
  end

  # https://www.imagemagick.org/discourse-server/viewtopic.php?t=33626
  def copy_tiff(file)
    copied = Tempfile.new(["copy", ".tif"], binmode: true)
    system("tiffcp #{file.path} #{copied.path}", exception: true, err: File::NULL)
    copied
  end

  def mime_type
    @mime_type ||= `file --brief --mime-type #{sanitized_file_name}`.chomp
  end

  def sanitized_file_name
    # This is a bit paranoid as Ruby generates the file name
    @file.path.gsub(%r{[^\w/.-]}, "")
  end
end
