# frozen_string_literal: true
require 'sinatra'
require 'rubygems'
require 'mqtt'
require 'json'
require 'sqlite3'
require 'net/ssh'

Dir.glob("#{File.dirname(__FILE__)}/*.rb").each do |file|
  require file
end
