get "/app/?" do
  username = params[:username]
  begin
    data=[]
    db = SQLite3::Database.open "./db/loramns.db"
    db.execute "SELECT * FROM Applications WHERE username = ?",username do |row|
      data << row
    end
    a = data.map {|s| {username:s[1], app_name: s[2], app_description: s[3]} }
    return a.to_json

  rescue SQLite3::Exception => e
    puts "Exception occurred"
    puts e
    halt 404, "LoRaWAN Application (username: #{username}) not found!"
  ensure
    db.close if db
  end
end

post "/create_app/?" do
  username = params[:username]
  app_name = params[:app_name]
  app_description = params[:app_description]
  begin
    db = SQLite3::Database.open "./db/loramns.db"
    db.execute "CREATE TABLE IF NOT EXISTS Applications (ID INTEGER PRIMARY KEY AUTOINCREMENT,
                                                         username TEXT,
                                                         app_name TEXT UNIQUE,
                                                         app_description TEXT
                                                         )"
    db.execute "INSERT INTO Applications VALUES(null,?,?,?)", username, app_name, app_description
  rescue SQLite3::Exception => e
    puts "Exception occurred"
    puts e
    halt 404, "LoRaWAN Applications (name: #{app_name}) cannot be created!"
  ensure
    db.close if db
  end
end

post "/delete_app/?" do
  username = params[:username]
  app_name = params[:app_name]
  begin
    db = SQLite3::Database.open "./db/loramns.db"
    db.execute "DELETE FROM Applications WHERE username=? AND app_name=?", username, app_name
  rescue SQLite3::Exception => e
    puts "Exception occurred"
    puts e
    halt 404, "LoRaWAN Application (name: #{app_name}) cannot be deleted!"
  ensure
    db.close if db
  end
end

# get the gateway info from gateway DB
get "/gateway/?" do
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

# get all nodes of an application of a user from DB
get "/node/?" do
  username = params[:username]
  app_name = params[:app_name]
  begin
    content_type 'application/json'
    data=[]
    db = SQLite3::Database.open "./db/loramns.db"
    db.execute "SELECT * FROM Nodes WHERE username = ? AND app_name = ? ",username, app_name do |row|
      data << row
    end
    a = data.map {|s| {username:s[1],app_name:s[2],node_addr:s[3],node_nwkskey:s[4],node_appskey:s[5]} }
    return a.to_json
  rescue SQLite3::Exception => e
    puts "Exception occurred"
    puts e
    halt 404, "LoRaWAN Node (username: #{username}, app_name:#{app_name}) not found!"
  ensure
    db.close if db
  end
end
