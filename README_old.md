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
`gem 'is_dark', '~> 0.1.9'`

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

#### Settings:
It also has kind of a development mode, when you can generate a debug outputs of all the generated dots based on provided coordinates. It can draw a test area over the file if you want, so you always can be sure, that you have valid coordinates on your tests. You can also set some other values and calibrate results as you need.

```ruby
IsDark.configure({
    percent: 70, #percent of dark dots under an area to mark all the area as dark
    matrix: (0..10), #range of dots to analyse. (0..10) means matrix 10x10 or 100 dots to analyse
    with_not_detected_as_white: true, # Sometimes Imagick can't detect a pixel or it has no color, so it detects it as (RGB: 0,0,0), the gem has an option to consider pixels like this as "white", but if you need to disable this option add true or false
    with_debug: true, #show debug output
    with_debug_file: true, #draw a tested area in a copy of your blob file
    debug_file_path: debug_file_path #path of the file with a drawn area
})
```
You can use these settings and test it after with this command:
`IsDark.magick_area_from_blob(x, y, blob, height, width)`, so it will show a debug info with a generated file

#### Unit Tests:

- `rspec` #rspec tests with a generated debug file

- `rake test` #minitest based unit tests (low amount of tests)