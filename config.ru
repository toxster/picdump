require 'rubygems'
require 'bundler'
Bundler.require
require 'sidekiq/web'
require './app'

#run PicDumpWeb.new
# /sidekiq should be protected, i know...
run Rack::URLMap.new('/' => PicDumpWeb.new, '/sidekiq' => Sidekiq::Web)
