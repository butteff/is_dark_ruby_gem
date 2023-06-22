Gem::Specification.new do |s|
  s.name        = "is_dark"
  s.version     = "0.0.3"
  s.summary     = "IsDark"
  s.description = "Detects a dark color based on luminance W3 standarts ( https://www.w3.org/TR/WCAG20/#relativeluminancedef ). \n\n It has these options: \n * is a hex color dark \n  * is an Imagick pixel dark \n * is an Imagick pixel from a blob dark \n * is an area in a blob over a dark background (uses Imagick for it too). \n\n An example practical aspect: it can be useful to understand will a black colored text be visible or not over an area."
  s.authors     = ["Sergei Illarionov"]
  s.email       = "illarionov@protonmail.com"
  s.files       = ["lib/is_dark.rb"]
  s.homepage    = "https://github.com/butteff/is_dark_ruby_gem"
  s.license     = "MIT"
  s.required_ruby_version = '>= 2.7.0'
  s.add_dependency 'rmagick', '~> 5.2'
  #s.add_development_dependency 'rmagick', '~> 5.2'
end