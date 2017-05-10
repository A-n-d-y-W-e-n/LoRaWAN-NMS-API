# frozen_string_literal: true
class LORAWAN_NMS_API < Sinatra::Base

  # get the gateway info from gateway DB
  get "/gateway/?" do
    # gateway_name = params[:gateway_name]
    begin
      content_type 'application/json'
      data=[]
      db = SQLite3::Database.open "./db/loramns.db"
      db.execute "SELECT * FROM Gateways " do |row|
        data << row
      end
      a = data.map {|s| {gw_name:s[1], gw_mac:s[2], gw_ip:s[3], gw_loc:s[4], gw_username:s[5]}}
      return a.to_json
    rescue SQLite3::Exception => e
      puts "Exception occurred"
      puts e
      halt 404, "LoRaWAN User (username: #{:username}) not found!"
    end
  end

  # insert the gateway info into DB
  post "/add_gateway/?" do
    gateway_name = params[:gateway_name]
    gateway_mac = params[:gateway_mac]
    gateway_ip = params[:gateway_ip]
    gateway_loc = params[:gateway_loc]
    gateway_username = params[:gateway_username]
    begin
      db = SQLite3::Database.open "./db/loramns.db"
      db.execute "CREATE TABLE IF NOT EXISTS Gateways (ID INTEGER PRIMARY KEY AUTOINCREMENT,
                                                       gateway_name TEXT UNIQUE,
                                                       gateway_mac TEXT UNIQUE,
                                                       gateway_ip  TEXT UNIQUE,
                                                       gateway_loc,
                                                       username TEXT
                                                       )"
      db.execute "INSERT INTO Gateways VALUES(null,?,?,?,?,?)", gateway_name, gateway_mac, gateway_ip, gateway_loc, gateway_username
    rescue SQLite3::Exception => e
      puts "Exception occurred"
      puts e
      halt 404, "LoRaWAN Gateway (MAC Address: #{gateway_mac}) cannot be created!"
    ensure
      db.close if db
    end
  end

  # delete the gateway info from DB
  post "/delete_gateway/?" do
    gateway_mac = params[:gateway_mac]
    begin
      db = SQLite3::Database.open "./db/loramns.db"
      db.execute "DELETE FROM Gateways WHERE gateway_mac=? ", gateway_mac
    rescue SQLite3::Exception => e
      puts "Exception occurred"
      puts e
      halt 404, "LoRaWAN Gateway (MAC Address: #{gateway_mac}) cannot be deleted!"
    ensure
      db.close if db
    end
  end

end
