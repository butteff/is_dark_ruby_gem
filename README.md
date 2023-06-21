# is_dark Ruby Gem
Ruby Gem to detect a dark color based on [luminance w3 standarts]( https://www.w3.org/TR/WCAG20/#relativeluminancedef "luminance w3 standarts") 

#### Can detect: 
* is a hex color dark
* is an Imagick pixel dark
* is an Imagick pixel from a blob dark
*  is an area in a blob over a dark background (uses Imagick for it too).

####How to use:
1. Declare a lib:
`require 'is_dark'`

2. Is Hex color dark:
`IsDark.color('#ffffff') => false`

3. is Imagick pixel dark:
`IsDark.magick_pixel(pix)`

3. is Imagick pixel from a blob dark by coordinates:
`IsDark.magick_pixel_from_blob(x, y, blob)`

4. is Imagick area from a blob dark (by coordinates of a dot + width and height from the dot) [it takes few more pixels in the area to have an analitics]
`IsDark.magick_area_from_blob(x, y, blob, height, width)`

where height is from top (y) to down
width is from left (x) to right