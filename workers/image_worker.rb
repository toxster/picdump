require "rubygems"
require "bundler"
require "open-uri"
require_relative "../config.rb"
require_relative "../uploaders/image_uploader"
Bundler.require


# sidekiq worker
class ImageWorker 
  include Sidekiq::Worker

  def perform(image_url)
    image_uri = URI.parse(image_url)
    uploader = ImageUpload.new
    uploader.store!(open(image_uri, :http_basic_authentication => ['api', MAILGUN_API_KEY]))
    uploaded_name = uploader.instance_variable_get(:@name)
    image_key = File.basename(uploaded_name, File.extname(uploaded_name))
    $redis.pipelined do
      $redis.hmset "image:#{image_key}", "url", uploader.url, "upload_date", Time.now.to_i # metadata
      $redis.lpush "images", "image:#{image_key}" # our list to loop
      $redis.incr "counter:images" 
    end
  end
end
