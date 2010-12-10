require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require :default
require 'sinatra/base'

module Filemine
  class Server < Sinatra::Base
    get '/' do
      "hello anthony"
    end
  end
end
