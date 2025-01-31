# is_dark Ruby Gem
Ruby Gem to detect a dark color over an area from a blob of a file or by a color hex code based on [luminance w3 standarts]( https://www.w3.org/TR/WCAG20/#relativeluminancedef "luminance w3 standarts") 

https://github.com/user-attachments/assets/430cd789-1b5d-42a0-ae6e-c8b5f1da694b

#### Can detect: 
* is a hex color dark
* is an Imagick pixel dark
* is an Imagick pixel from a blob dark
*  is an area in a blob over a dark background (uses Imagick for it too).
.
An example practical aspect: it can be useful to understand will a black colored text be visible or not over an area.

#### How to Install:

Gemfile: 
`gem 'is_dark', '~> 0.2.2'`

Install: 
`gem install is_dark`

#### How to use:
1. Declare a lib:
`require 'is_dark'`

2. Make an instance:
`is_dark = IsDark.new`

2. Is Hex color dark:
`is_dark.color('#ffffff')` => false

3. is Imagick pixel dark:
`is_dark.magick_pixel(pix)`

4. is Imagick pixel from a blob dark by coordinates:
`is_dark.magick_pixel_from_blob(x, y, blob)`

5. is Imagick area from a blob dark (by coordinates of a dot + width and height from the dot):
`is_dark.magick_area_from_blob(x, y, blob, height, width)` #standart default settings

#### Settings:
It also has kind of a development mode, when you can generate a debug outputs of all the generated dots based on provided coordinates. It can draw a test area over the file if you want, so you always can be sure, that you have valid coordinates during your tests. You can also set some other values and calibrate results as you need. You can just initialize an instance with these settings or update an existed one:

```ruby
params = {
    percent: 70, #percent of dark dots under an area to mark all the area as dark
    matrix: (0..10), #range of dots to analyse. (0..10) means matrix 10x10 or 100 dots to analyse
    with_not_detected_as_white: true, # Sometimes Imagick can't detect a pixel or it has no color, so it detects it as (RGB: 0,0,0), the gem has an option to consider pixels like this as "white", but if you need to disable this option add true or false
    with_debug: true, #show debug output
    with_debug_file: true, #draw a tested area in a copy of your blob file
    debug_file_path: debug_file_path, #path of the file with a drawn area
    luminance: 0.05 # all pixels are dark if their luminance is lower, that this value
}
is_dark = IsDark.new(params) #to generate new Instance
#or
is_dark.configure(params) #to update existed instance

```

You can use these settings and test it after with this command:
`is_dark.magick_area_from_blob(x, y, blob, height, width)`, so it will show a debug info with a generated file like in the video at the top of this documentation.

###### Deep Settings:

You can calibrate it more deep, change constants for it inside lib/is_dark.rb file, but the most powerful parameter to calibrate in case of a not valid dark area detection is about luminance value, it is open to change this value from settings params, it is already described in the message above.

#### Unit Tests:

- run `rspec` command to run tests with a generated debug file

#### Old versions:

Old versions of the gem are about static methods only, you can find old documentation about it all in [README_old.md file]( https://github.com/butteff/is_dark_ruby_gem/blob/main/README_old.md "README_old.md file")
