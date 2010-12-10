source 'http://rubygems.org'
gem 'nokogiri'
gem 'resque'

group :server do
  gem 'sinatra'
end

group :development, :test do
  gem 'rack-test', :require => false
  gem 'test-unit', :require => false
end

module Filemine
  autoload :Server, 'filemine/server'
end