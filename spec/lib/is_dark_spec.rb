# frozen_string_literal: true

require 'rmagick'
require 'spec_helper'
require_relative '../../lib/is_dark'

TEST_FILE_PATH = 'color_card.pdf'

describe IsDark do
  describe '.color' do
    context 'dark colors tests' do
      it 'this color #000000 is dark, returns true' do
        is_dark = IsDark.new
        expect(is_dark.color('#000000')).to eq(true)
      end

      it 'this color #111111 is dark, returns true' do
        is_dark = IsDark.new
        expect(is_dark.color('#111111')).to eq(true)
      end

      it 'this color #102694 is dark, returns true' do
        is_dark = IsDark.new
        expect(is_dark.color('#102694')).to eq(true)
      end

      it 'this color #ff2e17 is dark, returns true' do
        is_dark = IsDark.new
        expect(is_dark.color('#800f03')).to eq(true)
      end
    end

    context 'not dark colors tests' do
      it 'this color is not dark, returns false' do
        is_dark = IsDark.new
        expect(is_dark.color('#444444')).to eq(false)
      end

      it 'this color is not dark, returns false' do
        is_dark = IsDark.new
        expect(is_dark.color('#888888')).to eq(false)
      end

      it 'this color is not dark, returns false' do
        is_dark = IsDark.new
        expect(is_dark.color('#ffffff')).to eq(false)
      end

      it 'this color is not dark, returns false' do
        is_dark = IsDark.new
        expect(is_dark.color('#fff6b2')).to eq(false)
      end
    end
  end

  describe '.magick_pixel_from_blob' do
    context 'test dark pixel' do
      it 'this pixel is dark, returns true' do
        x = 120
        y = 120
        is_dark = IsDark.new
        expect(is_dark.magick_pixel_from_blob(x, y, TEST_FILE_PATH)).to eq(true)
      end
    end

    context 'test not dark pixel' do
      it 'this pixel is not dark, returns false' do
        x = 720
        y = 120
        is_dark = IsDark.new
        expect(is_dark.magick_pixel_from_blob(x, y, TEST_FILE_PATH)).to eq(false)
      end
    end
  end

  describe '.magick_pixel' do
    context 'test dark pixel' do
      it 'this pixel is dark, returns true' do
        image = Magick::Image.read(TEST_FILE_PATH).first
        pix = image.pixel_color(80, 320)
        is_dark = IsDark.new
        expect(is_dark.magick_pixel(pix)).to eq(true)
      end
    end

    context 'test not dark pixel' do
      it 'this pixel is not dark, returns false' do
        image = Magick::Image.read(TEST_FILE_PATH).first
        pix = image.pixel_color(720, 120)
        is_dark = IsDark.new
        expect(is_dark.magick_pixel(pix)).to eq(false)
      end
    end
  end

  describe '.magick_area_from_blob' do
    context 'test dark area' do
      it 'this area is dark, returns true' do
        x = 120 # coordinate of a left corner of the area's rectangle X
        y = 120 # coordinate of a left corner of the area's rectangle Y
        cf_height = 64 # height of the area's rectangle
        cf_width = 128 # height of the area's rectangle
        is_dark = IsDark.new
        expect(is_dark.magick_area_from_blob(x, y, TEST_FILE_PATH, cf_height, cf_width)).to eq(false)
      end
    end

    context 'test bright area' do
      it 'this area is not dark, returns false' do
        x = 720 # coordinate of a left corner of the area's rectangle X
        y = 120 # coordinate of a left corner of the area's rectangle Y
        cf_height = 64 # height of the area's rectangle
        cf_width = 128 # height of the area's rectangle
        is_dark = IsDark.new
        expect(is_dark.magick_area_from_blob(x, y, TEST_FILE_PATH, cf_height, cf_width)).to eq(false)
      end
    end

    context 'test debug output' do
      it 'test area with logs and debug file' do
        x = 120 # coordinate of a left corner of the area's rectangle X
        y = 120 # coordinate of a left corner of the area's rectangle Y
        cf_height = 64 # height of the area's rectangle
        cf_width = 128 # height of the area's rectangle
        params = {
          percent: 70, # percent of detected dark pixels to mark as dark
          matrix: (1..10), # matrix of dots. Range of matrix to build dots 1..10 - means 10x10,
          with_not_detected_as_white: true, # to mark not detected pixels as white
          with_debug: true, # to show debug output
          with_debug_file: true, # to generate debug file to show a tested area
          debug_file_path: './is_dark_debug_file.pdf' # to show file path
        }
        is_dark = IsDark.new(params)
        expect(is_dark.magick_area_from_blob(x, y, TEST_FILE_PATH, cf_height, cf_width)).to eq(false)
      end
    end
  end
end
