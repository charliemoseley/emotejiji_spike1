ENV['RACK_ENV'] ||= 'test'

require 'rubygems'
require 'bundler/setup'

Bundler.require :default, ENV['RACK_ENV']

$LOAD_PATH.unshift *Dir.glob(File.expand_path("../../app/**", __FILE__))
$LOAD_PATH.unshift *Dir.glob(File.expand_path("../../app/**/**", __FILE__))

require 'app/emotejiji_app'