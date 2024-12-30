# frozen_string_literal: true

require 'rmagick'

# The `Is Dark` class is designed to determine whether a given color or pixel is dark based on luminance
# standards defined by the W3C. It utilizes the `rmagick` library to handle image processing tasks.
# The class includes methods to analyze colors from hexadecimal values, individual pixels,
# and areas within images blobs. It also supports debugging features to visualize the analysis process.
#
# Key features include:
# - **Color Analysis**: Determines if a color is dark based on its luminance.
# - **- **Pixel Analysis**: Analysis individual pixels from an image.
# - **Area Analysis**: Evaluates the darkness of a specified area within an image blob.
# - **Debugging**: Provides options to enable debugging information and visualize the analysis on a PDF file.
class IsDark
  BLUE_LUMINANCE_COEFFICIENT = 0.0722
  GREEN_LUMINANCE_COEFFICIENT = 0.7152
  HIGH_LUMINANCE_DIVIDER = 1.055
  HIGH_LUMINANCE_POWER = 2.4
  LOW_LUMINANCE_DIVIDER = 12.92
  LUMINANCE_THRESHOLD = 0.05
  MAXIMUM_COLOR_DEPTH = 255
  MAX_COLOR_VALUE_MULTIPLIER = 655
  MAX_COLOR_VALUE = MAX_COLOR_VALUE_MULTIPLIER * MAXIMUM_COLOR_DEPTH
  LINEAR_LUMINANCE_THRESHOLD = (1 / (LOW_LUMINANCE_DIVIDER * 100.0)) * MAXIMUM_COLOR_DEPTH
  NONLINEAR_TRANSFORM_DIVIDER = 1.055
  NONLINEAR_TRANSFORM_OFFSET = 0.055
  RED_LUMINANCE_COEFFICIENT = 0.2126
  DEFAULT_PERCENT_OF_DOTS = 80
  DEFAULT_MATRIX_RANGE = (0..10).freeze
  DEFAULT_DEBUG_FILE_PATH = '/tmp/is_dark_debug_file.pdf'

  @r = 0
  @g = 0
  @b = 0
  @colorset = MAXIMUM_COLOR_DEPTH
  @percent = DEFAULT_PERCENT_OF_DOTS
  @matrix = DEFAULT_MATRIX_RANGE
  @with_not_detected_as_white = true
  @with_debug = false
  @with_debug_file = false
  @debug_file_path = DEFAULT_DEBUG_FILE_PATH

  def self.configure(settings)
    @percent = settings[:percent] || DEFAULT_PERCENT_OF_DOTS
    @matrix = settings[:matrix] || DEFAULT_MATRIX_RANGE
    @with_not_detected_as_white = settings[:with_not_detected_as_white] || true
    @with_debug = settings[:with_debug] || false
    @with_debug_file = settings[:with_debug_file] || false
    @debug_file_path = settings[:debug_file_path] || DEFAULT_DEBUG_FILE_PATH
  end

  def self.color(hex)
    @r, @g, @b = hex.match(/^#(..)(..)(..)$/).captures.map(&:hex)
    @colorset = MAXIMUM_COLOR_DEPTH
    dark?
  end

  def self.magick_pixel(pix, x = nil, y = nil)
    @r = pix.red.to_f
    @g = pix.green.to_f
    @b = pix.blue.to_f
    @colorset = MAX_COLOR_VALUE
    dark?(x, y)
  end

  def self.magick_pixel_from_blob(x, y, blob)
    image = Magick::Image.read(blob).first
    pix = image.pixel_color(x, y)
    magick_pixel(pix, x, y)
  end

  # (x, y) is the left corner of an element over a blob, height and width is the element's size
  def self.magick_area_from_blob(x, y, blob, height, width)
    image = Magick::Image.read(blob).first
    dark = false
    dots = []
    @matrix.each do |xx|
      @matrix.each do |yy|
        dots << { x: (x + (width * xx / 10)).to_i, y: (y + (height * yy / 10)).to_i }
      end
    end

    points = 0
    if @with_debug_file
      old_x = false
      old_y = false
    end
    p '==================================================================================' if @with_debug
    dots.each do |dot|
      x = dot[:x].to_i
      y = dot[:y].to_i
      pix = image.pixel_color(x, y)
      l = magick_pixel(pix, x, y)
      points += 1 if l
      next unless @with_debug_file

      draw_debug_files(image, x, y, old_x, old_y)
      old_y = y
      old_x = x
    end
    dark = true if points >= (dots.length / 100) * @percent
    if @with_debug
      p '=================================================================================='
      p "Total Points: #{dots.length}, dark points amount:#{points}"
      p "Is \"invert to white not detectd pixels\" option enabled?:#{@with_not_detected_as_white}"
      p "Signature will be inverted if #{@percent}% of dots will be dark"
      p "Is inverted?: #{dark}"
      p "have a look on #{@debug_file_path} file to see your tested area of a blob"
      p '=================================================================================='
    end
    dark
  end

  def self.draw_debug_files(image, x, y, old_x, old_y)
    return unless old_x && old_y

    gc = Magick::Draw.new
    gc.line(x, y, old_x, old_y)
    gc.stroke('black')
    gc.draw(image)
    image.write(@debug_file_path)
  end

  # detects a dark color based on luminance W3 standarts ( https://www.w3.org/TR/WCAG20/#relativeluminancedef )
  def self.dark?(x = nil, y = nil)
    dark = false
    inverted = false
    pixel = [@r.to_f, @g.to_f, @b.to_f]
    return true if pixel == [0.00, 0.00, 0.00] # hardcoded exception

    if @with_not_detected_as_white && pixel[0] == 0.0 && pixel[1] == 0.0 && pixel[2] == 0.0
      pixel = [MAXIMUM_COLOR_DEPTH, MAXIMUM_COLOR_DEPTH, MAXIMUM_COLOR_DEPTH]
      inverted = true
    end
    calculated = []
    pixel.each do |color|
      color /= @colorset
      if color <= LINEAR_LUMINANCE_THRESHOLD
        color /= LOW_LUMINANCE_DIVIDER
      else
        color = ((color + NONLINEAR_TRANSFORM_OFFSET) / NONLINEAR_TRANSFORM_DIVIDER)**HIGH_LUMINANCE_POWER
      end
      calculated << color
    end
    l = (RED_LUMINANCE_COEFFICIENT * calculated[0]) +
        (GREEN_LUMINANCE_COEFFICIENT * calculated[1]) +
        (BLUE_LUMINANCE_COEFFICIENT * calculated[2])
    dark = true if l <= LUMINANCE_THRESHOLD
    if @with_debug
      debug = { X: x, Y: y, R: @r, G: @g, B: @b, 'luminance value': l, dark?: dark,
                'inverted to white': inverted }
      p debug
    end
    dark
  end
end
