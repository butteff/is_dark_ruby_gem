Gem::Specification.new do |s|
  s.name        = "is_dark"
  s.version     = "0.0.1"
  s.summary     = "IsDark"
  s.description = "Ruby Gem to detect a dark color based on luminance W3 standarts ( https://www.w3.org/TR/WCAG20/#relativeluminancedef ). Can detect is a hex color dark, is an Imagick pixel dark, is an Imagick pixel from a blob dark, is an area in a blob over a dark background (uses Imagick for it too)."
  s.authors     = ["Sergei Illarionov"]
  s.email       = "illarionov@protonmail.com"
  s.files       = ["lib/is_dark.rb"]
  s.homepage    = "https://github.com/butteff/is_dark_ruby_gem"
  s.license     = "MIT"
end