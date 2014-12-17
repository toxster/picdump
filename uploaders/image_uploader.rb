require "rubygems"
require "bundler"
require "carrierwave"
require_relative "../config.rb"
Bundler.require

class ImageUpload < CarrierWave::Uploader::Base
  require 'carrierwave/processing/mime_types'
  require 'carrierwave/processing/mini_magick'
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes
  storage :fog
  process :resize_and_pad => [400, 300]
  process :convert => 'png' 
  process :set_content_type => 'image/png'
  
  # store name as a uuid, prevents duplicates. 
  def filename()
    @name ||= "#{SecureRandom.hex()}.png"
  end
  # store by YYYYMM format. 
  def store_dir
    "uploads/#{DateTime.now.strftime('%Y%m')}/"
  end
end

