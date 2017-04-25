# frozen_string_literal: true
require 'sinatra'
require 'rubygems'
require 'mqtt'
require 'json'
require 'sqlite3'
require 'net/ssh'

class LORAWAN_NMS_API < Sinatra::Base

  # get all applications of a user from DB
  get "/app/:username/?" do
    username = params[:username]
    begin
      db = SQLite3::Database.open "./db/loramns.db"
      db.execute "SELECT DISTINCT app_name FROM Applications WHERE username = ?",username do |row|
        return row
      end
    rescue SQLite3::Exception => e
      puts "Exception occurred"
      puts e
      halt 404, "LoRaWAN Application (username: #{username}) not found!"
    ensure
      db.close if db
    end
  end

  # get all nodes of an application of a user from DB
  get "/app/:username/:app_name/?" do
    username = params[:username]
    app_name = params[:app_name]
    begin
      db = SQLite3::Database.open "./db/loramns.db"
      db.execute "SELECT node_addr FROM Applications WHERE username = ? AND app_name = ? ",username, app_name do |row|
        return row
      end
    rescue SQLite3::Exception => e
      puts "Exception occurred"
      puts e
      halt 404, "LoRaWAN Node (username: #{username}, app_name:#{app_name}) not found!"
    ensure
      db.close if db
    end
  end

  # get the last received data of a node from DB
  get "/node/:node_addr/?" do
    node_addr = '00000000' + params[:node_addr]
    puts node_addr
    begin
      db = SQLite3::Database.open "./db/loramns.db"
      db.execute "SELECT * FROM Nodes WHERE macAddr = ? ORDER BY ID DESC LIMIT 1",node_addr do |row|
        return row
      end
    rescue SQLite3::Exception => e
      puts "Exception occurred"
      puts e
      halt 404, "LoRaWAN Node (address: #{:node_addr}) not found!"
    end
  end

  # insert the info of a node into DB
  post "/app/:username/:app_name/:node_addr/?" do
    username = params[:username]
    app_name = params[:app_name]
    node_addr = params[:node_addr]
    begin
      db = SQLite3::Database.open "./db/loramns.db"
      db.execute "CREATE TABLE IF NOT EXISTS Applications (ID INTEGER PRIMARY KEY AUTOINCREMENT,
                                                           username TEXT,
                                                           app_name TEXT,
                                                           node_addr TEXT UNIQUE
                                                           )"
      db.execute "INSERT INTO Applications VALUES(null,?,?,?)", username, app_name, node_addr
    rescue SQLite3::Exception => e
      puts "Exception occurred"
      puts e
      halt 404, "LoRaWAN Application (name: #{app_name}) cannot be created!"
    ensure
      db.close if db
    end
  end

  # insert the key of the node into dateway DB
  post "/node/abp/:DevAddr/:NwkSKey/:AppSKey/?" do
    @hostname = '192.168.88.1'
    @username = 'root'
    @password = 'gemtek'
    DevAddr = params[:DevAddr]
    NwkSKey = params[:NwkSKey]
    AppSKey = params[:AppSKey]
    begin
      ssh = Net::SSH.start(@hostname, @username, :password => @password)
      res = ssh.exec!("sqlite3 /app/db/lora.db \
                       \"INSERT INTO table_abp VALUES ( \'#{DevAddr}\', \'#{NwkSKey}\', \'#{AppSKey}\' );\"
                      ")
      ssh.close
      puts res
    rescue
      halt 404, "Unable to connect to #{@hostname} using #{@username}/#{@password}!"
    end
  end

  # get the gateway info from gateway DB
  get "/gateway/:gateway_name?" do
    gateway_name = params[:gateway_name]
    begin
      db = SQLite3::Database.open "./db/loramns.db"
      db.execute "SELECT gateway_mac FROM Gateways WHERE gateway_name = ? ",gateway_name do |row|
        return row
      end
    rescue SQLite3::Exception => e
      puts "Exception occurred"
      puts e
      halt 404, "LoRaWAN User (username: #{:username}) not found!"
    end
  end

  # insert the gateway info into DB
  post "/gateway/:gateway_name/:gateway_mac/:gateway_ip/?" do
    gateway_name = params[:gateway_name]
    gateway_mac = params[:gateway_mac]
    gateway_ip = params[:gateway_ip]
    begin
      db = SQLite3::Database.open "./db/loramns.db"
      db.execute "CREATE TABLE IF NOT EXISTS Gateways (ID INTEGER PRIMARY KEY AUTOINCREMENT,
                                                       gateway_name TEXT UNIQUE,
                                                       gateway_mac TEXT UNIQUE,
                                                       gateway_ip  TEXT UNIQUE
                                                       )"
      db.execute "INSERT INTO Gateways VALUES(null,?,?,?)", gateway_name, gateway_mac, gateway_ip
    rescue SQLite3::Exception => e
      puts "Exception occurred"
      puts e
      halt 404, "LoRaWAN Gateway (MAC Address: #{gateway_mac}) cannot be created!"
    ensure
      db.close if db
    end
  end

  # get the user info from DB
  get "/user/:username/?" do
    username = params[:username]
    begin
      db = SQLite3::Database.open "./db/loramns.db"
      db.execute "SELECT password FROM Users WHERE username = ? ",username do |row|
        return row
      end
    rescue SQLite3::Exception => e
      puts "Exception occurred"
      puts e
      halt 404, "LoRaWAN User (username: #{:username}) not found!"
    end
  end

  # insert the user info into DB
  post "/user/:username/:password/?" do
    username = params[:username]
    password = params[:password]
    begin
      db = SQLite3::Database.open "./db/loramns.db"
      db.execute "CREATE TABLE IF NOT EXISTS Users (ID INTEGER PRIMARY KEY AUTOINCREMENT,
                                                    username TEXT UNIQUE,
                                                    password TEXT
                                                    )"
      db.execute "INSERT INTO Users VALUES(null,?,?)", username, password
    rescue SQLite3::Exception => e
      puts "Exception occurred"
      puts e
      halt 404, "LoRaWAN User (username: #{username}) cannot be created!"
    ensure
      db.close if db
    end
  end

end
