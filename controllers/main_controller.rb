# frozen_string_literal: true
require 'sinatra'
require 'rubygems'
require 'mqtt'
require 'json'
require 'sqlite3'

class LORAWAN_NMS_API < Sinatra::Base
  get "/node/:node_addr/?" do
    node_addr = params[:node_addr]
    begin
      group = FaceGroup::Group.find(id: group_id)
      content_type 'application/json'
      { group_id: group.id, name: group.name }.to_json
    rescue
      halt 404, "LoRaWAN Node (address: #{:node_addr}) not found"
    end
  end

  get "/app/:username/?" do
    username = params[:username]
    begin
      db = SQLite3::Database.open "db/loramns.db"
      db.execute "SELECT app_name FROM Applications WHERE username = ?",username
    rescue SQLite3::Exception => e
      puts "Exception occurred"
      puts e
      halt 404, "LoRaWAN Application (username: #{username}) not found"
    ensure
      db.close if db
    end
  end

  get "/app/:username/:app_name/?" do
    app_name = params[:app_name]
    begin

    rescue SQLite3::Exception => e
      puts "Exception occurred"
      puts e
      halt 404, "LoRaWAN Application (name: #{app_name}) cannot be created"
    ensure
      db.close if db
    end
  end

  post "/app/:username/:app_name/:node_addr/?" do
    username = params[:username]
    app_name = params[:app_name]
    node_addr = params[:node_addr]
    begin
      db = SQLite3::Database.open "./db/loramns.db"
      db.execute "CREATE TABLE IF NOT EXISTS Applications (username TEXT,
                                                           app_name TEXT,
                                                           node_addr TEXT
                                                           )"
      db.execute "INSERT INTO Applications VALUES(?,?,?)", username, app_name, node_addr
    rescue SQLite3::Exception => e
      puts "Exception occurred"
      puts e
      halt 404, "LoRaWAN Application (name: #{app_name}) cannot be created"
    ensure
      db.close if db
    end
  end

  post "/node/:node_addr/?" do
    node_addr = params[:node_addr]
    begin

    rescue

    end
  end

  post "/node/:node_addr/?" do
    node_addr = params[:node_addr]
    begin

    rescue

    end
  end

  post "/node/:node_addr/?" do
    node_addr = params[:node_addr]
    begin

    rescue

    end
  end
end
