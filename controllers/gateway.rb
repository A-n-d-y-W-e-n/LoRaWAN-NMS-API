# frozen_string_literal: true
class LORAWAN_NMS_API < Sinatra::Base

  # insert the key of the node into gateway DB
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
      db.execute "SELECT * FROM Gateways WHERE gateway_name = ? ",gateway_name do |row|
        return row.to_json
      end
      content_type 'application/json'
    rescue SQLite3::Exception => e
      puts "Exception occurred"
      puts e
      halt 404, "LoRaWAN User (username: #{:username}) not found!"
    end
  end

  # insert the gateway info into DB
  post "/gateway/:gateway_name/:gateway_mac/:gateway_ip/:gateway_loc/?" do
    gateway_name = params[:gateway_name]
    gateway_mac = params[:gateway_mac]
    gateway_ip = params[:gateway_ip]
    gateway_loc = params[:gateway_loc]
    begin
      db = SQLite3::Database.open "./db/loramns.db"
      db.execute "CREATE TABLE IF NOT EXISTS Gateways (ID INTEGER PRIMARY KEY AUTOINCREMENT,
                                                       gateway_name TEXT UNIQUE,
                                                       gateway_mac TEXT UNIQUE,
                                                       gateway_ip  TEXT UNIQUE,
                                                       gateway_loc
                                                       )"
      db.execute "INSERT INTO Gateways VALUES(null,?,?,?,?)", gateway_name, gateway_mac, gateway_ip, gateway_loc
    rescue SQLite3::Exception => e
      puts "Exception occurred"
      puts e
      halt 404, "LoRaWAN Gateway (MAC Address: #{gateway_mac}) cannot be created!"
    ensure
      db.close if db
    end
  end
end
