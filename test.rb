# frozen_string_literal: true
require 'rubygems'
require 'mqtt'
require 'json'
require 'sqlite3'

username = 'greenhouse'

begin
  db = SQLite3::Database.open "db/loramns.db"
  db.execute "SELECT app_name FROM Applications WHERE username = ?",username do |row|
    p row
  end

rescue SQLite3::Exception => e
  puts "Exception occurred"
  puts e
ensure
  db.close if db
end
