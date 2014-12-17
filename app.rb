require 'rubygems'
require 'bundler'
Bundler.require
require 'sinatra/base'
require 'json'
require 'uri'
require_relative './workers/image_worker'
require_relative './config'

# our sinatra app
class PicDumpWeb < Sinatra::Base
  
  get '/' do
    File.read(File.join('public', 'index.html'))
  end

  post '/api/v1/mailnotify' do
    attachments = JSON.parse(params['attachments'])
    attachments.each do |attachment|
      # validate that they sent the right stuff, perhaps also implement a upper size limiter?
      if VALID_IMAGE_FORMATS.include? attachment['content-type'].downcase
        ImageWorker.perform_async(attachment['url'])
      else
        puts "invalid content-type received, send an e-mail complaining to the user."
      end
    end
    [200,{"Content-Type" => "text/plain"}, ["Thank you"]]
  end

  get '/api/v1/pictures.json' do
    content_type :json
    result = [] 
    piclist = $redis.lrange "images", 0, -1
    piclist.each do |img|
      image = $redis.hgetall "#{img}"
      result.push(image)
    end
    result.to_json
  end
end

