require 'rubygems'
require 'bundler'
require 'redis'
Bundler.setup
Bundler.require :default
require 'sinatra/base'

module Filemine
  class Server < Sinatra::Base
    set :public, File.dirname(__FILE__) + '/public'
    
    get '/index' do
      @path = my_file
      erb :index
    end
    
    get '/project_name/files/:file_key' do
      send_file(redis.get(params[:file_key])) 
      # now output the file
    end
    
    def my_file
      digest =  Digest::MD5.hexdigest(File.read("Capfile.zip"))
      redis.set(digest, File.expand_path("Capfile.zip"))
      digest
    end
    
    def redis
      Redis.new
    end
  end
end