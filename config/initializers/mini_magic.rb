# how to make this line work
require 'mini_magick'
# include CarrierWave::MiniMagick

MiniMagick.configure do |config|
  config.shell_api = "posix-spawn"
end