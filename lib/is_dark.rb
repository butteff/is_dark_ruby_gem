class IsDark
	@r = false
	@g = false
	@b = false
	@colorset = 255

	def self.color(hex)
		@r, @g, @b = hex.match(/^#(..)(..)(..)$/).captures.map(&:hex)
		@colorset = 255
		self.is_dark
	end

	def self.magick_pixel(pix)
      	@r, @g, @b = [pix.red.to_f, pix.green.to_f, pix.blue.to_f]
		@colorset = 655*255
		self.is_dark
	end

	def self.magick_pixel_from_blob(x, y, blob)
		image = Magick::Image.read(blob).first
		pix = image.pixel_color(x, y)
      	self.magick_pixel(pix)
	end

	def self.magick_area_from_blob(x, y, blob, height, width)
	    image = Magick::Image.read(blob).first
	    dots = [{'x': x, 'y': y}, {'x': x+width, 'y': y}, {'x': x+width, 'y': y-height}, {'x': x, 'y': y-height}, {'x': (x+width)/2, 'y': (y-height)/2}]
	    points = 0
	    dots.each { |dot|
	      x = dot[:x]
	      y = dot[:y]
	      pix = image.pixel_color(x, y)
	      l = self.magick_pixel(pix)
	      points += 1 if l
	    }
	    dark = true if points >= 3
	    dark
  	end

	private

	def self.is_dark
		dark = false
		pixel = [@r.to_f, @g.to_f, @b.to_f]
		calculated = []
		pixel.each { |color|
		    color = color/@colorset
		    color = color/12.92 if color <= 0.03928
		    color = ((color+0.055)/1.055)**2.4 if color > 0.03928
		    calculated << color
		}
		l = (0.2126*calculated[0] + 0.7152*calculated[1] + 0.0722*calculated[2])
		dark = true if l <= 0.05
		dark
	end
end