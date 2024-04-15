require "rmagick"
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
		self.is_dark
	end

	def self.magick_pixel(pix, x=nil, y=nil, set_not_detected_light=true)
    @r, @g, @b = [pix.red.to_f, pix.green.to_f, pix.blue.to_f]
		@colorset = 655*255
		is = self.is_dark(x, y, set_not_detected_light)
    is
	end

	def self.magick_pixel_from_blob(x, y, blob, set_not_detected_light=true)
		image = Magick::Image.read(blob).first
		pix = image.pixel_color(x, y)
    self.magick_pixel(pix, x, y)
	end
																	 
  def self.magick_area_from_blob(x, y, blob, height, width, percent=80, range=(0..10), set_not_detected_light=true) # (x, y) is the left corner of an element over a blob, height and width is the element's size
    @set_not_detected_light = set_not_detected_light
    image = Magick::Image.read(blob).first
    dark = false
    dots = []
    range.each { |xx|
      range.each { |yy|
        dots << {'x': (x+width*xx/10).to_i, 'y': (y+height*yy/10).to_i}
      }
    }

    points = 0
    if @with_debug_file
    	oldx = false
    	oldy = false
    end
    p '====================================================================' if @with_debug
    dots.each { |dot|
      x = dot[:x].to_i
      y = dot[:y].to_i
      pix = image.pixel_color(x, y)
      l = self.magick_pixel(pix, x, y, set_not_detected_light)
      points += 1 if l
      if @with_debug_file
      	self.draw_debug_files(image, x, y, oldx, oldy) 
      	oldy = y
      	oldx = x
      end
    }
    dark = true if points >= (dots.length/100)*percent
    if @with_debug
    	p '===================================================================='
    	p 'Total Points: '+dots.length.to_s+', dark points amount:'+points.to_s
    	p 'Is "invert to white not detectd pixels" option enabled?:'+set_not_detected_light.to_s
    	p 'Signature will be inverted if '+percent.to_s+'% of dots will be dark'
    	p 'Is inverted?: '+dark.to_s
    	p '===================================================================='
    end
    dark
  end

  def self.set_debug_data(show_info=false, draw_file=false)
    @with_debug=show_info
    if draw_file != false
    	@with_debug_file = true
    	@debug_file_path = draw_file
    end
  end

	private

	def self.draw_debug_files(image, x, y, oldx, oldy)
		if oldx && oldy
			gc = Magick::Draw.new
			gc.line(x, y, oldx, oldy)
			gc.stroke('black')
			gc.draw(image)
			image.write(@debug_file_path)
		end
	end

	def self.is_dark(x=nil, y=nil, set_not_detected_light=true) #detects a dark color based on luminance W3 standarts ( https://www.w3.org/TR/WCAG20/#relativeluminancedef )
		dark = false
		inverted = false
		pixel = [@r.to_f, @g.to_f, @b.to_f]
		if set_not_detected_light && pixel[0] == 0.0 && pixel[1] == 0.0 && pixel[2] == 0.0 #probably not detected pixel color by Imagick, will be considered as "white" if "set_not_detected_light = true"
			pixel = [65535.0, 65535.0, 65535.0]
			inverted = true 
		end
		calculated = []
		pixel.each { |color|
		  color = color/@colorset
		  color = color/12.92 if color <= 0.03928
		  color = ((color+0.055)/1.055)**2.4 if color > 0.03928
		  calculated << color
		}
		l = (0.2126*calculated[0] + 0.7152*calculated[1] + 0.0722*calculated[2])
		dark = true if l <= 0.05
		if @with_debug
			debug = {'X': x, 'Y': y, 'R': @r, 'G': @g, 'B': @b, 'luminance value': l, 'is_dark': dark, 'inverted to white': inverted }
			p debug
		end
		dark
	end
end