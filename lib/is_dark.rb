# frozen_string_literal: true

require 'rmagick'
class IsDark
  @r = 0
  @g = 0
  @b = 0
  @colorset = 255
  @with_debug = false
  @with_debug_file = false
  @debug_file_path = '/tmp/is_dark_debug_file.pdf'

  def self.color(hex)
    @r, @g, @b = hex.match(/^#(..)(..)(..)$/).captures.map(&:hex)
    @colorset = 255
    is_dark
  end

  def self.magick_pixel(pix, x = nil, y = nil, set_not_detected_light = true)
    @r = pix.red.to_f
    @g = pix.green.to_f
    @b = pix.blue.to_f
    @colorset = 655 * 255
    is_dark(x, y, set_not_detected_light)
  end

  def self.magick_pixel_from_blob(x, y, blob, _set_not_detected_light = true)
    image = Magick::Image.read(blob).first
    pix = image.pixel_color(x, y)
    magick_pixel(pix, x, y)
  end

  # (x, y) is the left corner of an element over a blob, height and width is the element's size
  def self.magick_area_from_blob(x, y, blob, height, width, percent = 80, range = (0..10), set_not_detected_light = true)
    @set_not_detected_light = set_not_detected_light
    image = Magick::Image.read(blob).first
    dark = false
    dots = []
    range.each do |xx|
      range.each do |yy|
        dots << { 'x': (x + width * xx / 10).to_i, 'y': (y + height * yy / 10).to_i }
      end
    end

    points = 0
    if @with_debug_file
      oldx = false
      oldy = false
    end
    p '====================================================================' if @with_debug
    dots.each do |dot|
      x = dot[:x].to_i
      y = dot[:y].to_i
      pix = image.pixel_color(x, y)
      l = magick_pixel(pix, x, y, set_not_detected_light)
      points += 1 if l
      next unless @with_debug_file

      draw_debug_files(image, x, y, oldx, oldy)
      oldy = y
      oldx = x
    end
    dark = true if points >= (dots.length / 100) * percent
    if @with_debug
      p '===================================================================='
      p "Total Points: #{dots.length}, dark points amount:#{points}"
      p "Is \"invert to white not detectd pixels\" option enabled?:#{set_not_detected_light}"
      p "Signature will be inverted if #{percent}% of dots will be dark"
      p "Is inverted?: #{dark}"
      p '===================================================================='
    end
    dark
  end

  def self.set_debug_data(show_info = false, draw_file = false)
    @with_debug = show_info
    return unless draw_file != false

    @with_debug_file = true
    @debug_file_path = draw_file
  end

  def self.draw_debug_files(image, x, y, oldx, oldy)
    return unless oldx && oldy

    gc = Magick::Draw.new
    gc.line(x, y, oldx, oldy)
    gc.stroke('black')
    gc.draw(image)
    image.write(@debug_file_path)
  end

  # detects a dark color based on luminance W3 standarts ( https://www.w3.org/TR/WCAG20/#relativeluminancedef )
  def self.is_dark(x = nil, y = nil, set_not_detected_light = true)
    dark = false
    inverted = false
    pixel = [@r.to_f, @g.to_f, @b.to_f]
    if set_not_detected_light && pixel[0] == 0.0 && pixel[1] == 0.0 && pixel[2] == 0.0 # probably not detected pixel color by Imagick, will be considered as "white" if "set_not_detected_light = true"
      pixel = [65_535.0, 65_535.0, 65_535.0]
      inverted = true
    end
    calculated = []
    pixel.each do |color|
      color /= @colorset
      color /= 12.92 if color <= 0.03928
      color = ((color + 0.055) / 1.055)**2.4 if color > 0.03928
      calculated << color
    end
    l = (0.2126 * calculated[0] + 0.7152 * calculated[1] + 0.0722 * calculated[2])
    dark = true if l <= 0.05
    if @with_debug
      debug = { 'X': x, 'Y': y, 'R': @r, 'G': @g, 'B': @b, 'luminance value': l, 'is_dark': dark,
                'inverted to white': inverted }
      p debug
    end
    dark
  end
end
