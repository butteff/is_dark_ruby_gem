# is_dark Ruby Gem
Ruby Gem to detect a dark color based on [luminance w3 standarts]( https://www.w3.org/TR/WCAG20/#relativeluminancedef "luminance w3 standarts") 

https://github.com/user-attachments/assets/b5c46ae5-b608-4588-a497-b3bd3eb690ef

#### Can detect: 
* is a hex color dark
* is an Imagick pixel dark
* is an Imagick pixel from a blob dark
*  is an area in a blob over a dark background (uses Imagick for it too).
.
An example practical aspect: it can be useful to understand will a black colored text be visible or not over an area.

#### How to Install:

Gemfile: 
`gem 'is_dark', '~> 0.0.3'`

Install: 
`gem install is_dark`

#### How to use:
1. Declare a lib:
`require 'is_dark'`

2. Is Hex color dark:
`IsDark.color('#ffffff') => false`

3. is Imagick pixel dark:
`IsDark.magick_pixel(pix)`

4. is Imagick pixel from a blob dark by coordinates:
`IsDark.magick_pixel_from_blob(x, y, blob)`

5. is Imagick area from a blob dark (by coordinates of a dot + width and height from the dot):
`IsDark.magick_area_from_blob(x, y, blob, height, width)` #standart default settings

#### More examples:
It also has kind of a development mode, when you can generate a debug outputs of all the generated dots based on provided coordinates. It can draw a test area over the file if you want, so you always can be sure, that you have valid coordinates on your tests.
- `IsDark.set_debug_data(true, false)` #with debug info outputs in logs

- `IsDark.set_debug_data(true, '/var/www/project/is_dark_debug_output.pdf')` #with a generated debug  pdf file (has displayed area of the analytics). You can use other file formats for the info (jpg, png, gif)

- `IsDark.magick_area_from_blob(x, y, blob, height, width)` #standart default settings

-   ` IsDark.magick_area_from_blob(x, y, blob, cf_height, cf_width, 60, (1..10))` #additional settings (percent of dark dots amount to mark an area as a dark, range of matrix to build dots 1..10 - means 10x10; 0..10 - will have 121 dots for the analytics)

Sometimes Imagick can't detect a pixel or it has no color, so it detects it as (RGB: 0,0,0), the gem has an option to consider pixels like this as "white", but if you need to disable this option add true or false at the end of the method:

-  ` IsDark.magick_area_from_blob(x, y, blob, cf_height, cf_width, 60, (1..10), false)` #detection "as white" is disabled)

#### Unit Tests:

- `cd spec && rspec test_is_dark.rb` #rspec tests with a generated debug file

- `rake test` #minitest based unit tests (low amount of tests)
