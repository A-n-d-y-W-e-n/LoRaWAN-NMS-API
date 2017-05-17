# frozen_string_literal: true
require 'sinatra'
require 'sequel'

ENV['DATABASE_URL'] = 'sqlite://db/loramns.db'
# ENV['DATABASE_URL'] = 'sqlite://db/loramns-old.db'

configure do
  DB = Sequel.connect(ENV['DATABASE_URL'])
  require 'hirb'
  Hirb.enable
end
