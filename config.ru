#!/usr/bin/env ruby
$LOAD_PATH.unshift ::File.expand_path('../lib', __FILE__)
require 'filemine/server'

run Filemine::Server.new