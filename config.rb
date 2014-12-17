require "carrierwave"

# see https://github.com/carrierwaveuploader/carrierwave/issues/1472#issuecomment-60514059
OpenURI::Buffer::StringMax = 0

# setup accepted image formats
VALID_IMAGE_FORMATS = [
  'image/png',
  'image/jpeg'
]

# setup redis
redis_url = ENV['REDIS_URL'] || 'redis://localhost:6379'
$redis = Redis.new(:url => redis_url)

# setup mailgun
MAILGUN_API_KEY = ENV['MAILGUN_API_KEY'] || "your-key"

# setup s3
AMAZON_ACCESS_KEY_ID = ENV['AMAZON_ACCESS_KEY_ID'] || "your-key-id"
AMAZON_SECRET_ACCESS_KEY = ENV['AMAZON_SECRET_ACCESS_KEY'] || "your-secrect-access-key"

# configure CarrierWave to use fog/s3
CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => AMAZON_ACCESS_KEY_ID,
      :aws_secret_access_key  => AMAZON_SECRET_ACCESS_KEY,
      :region                 => 'eu-west-1'                  
    }
    config.fog_directory  = 'muntr-picdump' # must be created prior to running
    config.fog_attributes = {'Cache-Control'=>"max-age=#{365.day.to_i}"} 
end
