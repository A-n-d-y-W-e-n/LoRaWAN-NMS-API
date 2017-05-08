# frozen_string_literal: true
class LORAWAN_NMS_API < Sinatra::Base

  # get all nodes of an application of a user from DB
  get "/node/:username/:app_name/?" do
    username = params[:username]
    app_name = params[:app_name]
    begin
      content_type 'application/json'
      data=[]
      db = SQLite3::Database.open "./db/loramns.db"
      db.execute "SELECT * FROM Nodes WHERE username = ? AND app_name = ? ",username, app_name do |row|
        data << row
      end
      a = data.map {|s| {username:s[1],app_name:s[2], node_addr:s[3]} }
      return a.to_json
    rescue SQLite3::Exception => e
      puts "Exception occurred"
      puts e
      halt 404, "LoRaWAN Node (username: #{username}, app_name:#{app_name}) not found!"
    ensure
      db.close if db
    end
  end

  # get the last received data of a node from DB
  get "/node_data/:node_addr/?" do
    node_addr = '00000000' + params[:node_addr]
    puts node_addr
    begin
      content_type 'application/json'
      data=[]
      db = SQLite3::Database.open "./db/loramns.db"
      db.execute "SELECT * FROM Nodes_data WHERE macAddr = ? ORDER BY ID DESC LIMIT 1",node_addr do |row|
        data << row.to_json
      end
      return data
    rescue SQLite3::Exception => e
      puts "Exception occurred"
      puts e
      halt 404, "LoRaWAN Node Data (address: #{:node_addr}) not found!"
    end
  end

  # insert the info of a node into DB
  post "/node/:username/:app_name/:node_addr/?" do
    username = params[:username]
    app_name = params[:app_name]
    node_addr = params[:node_addr]
    begin
      db = SQLite3::Database.open "./db/loramns.db"
      db.execute "CREATE TABLE IF NOT EXISTS Nodes (ID INTEGER PRIMARY KEY AUTOINCREMENT,
                                                           username TEXT,
                                                           app_name TEXT,
                                                           node_addr TEXT UNIQUE
                                                           )"
      db.execute "INSERT INTO Nodes VALUES(null,?,?,?)", username, app_name, node_addr
    rescue SQLite3::Exception => e
      puts "Exception occurred"
      puts e
      halt 404, "LoRaWAN Node (app_name: #{app_name}) cannot be created!"
    ensure
      db.close if db
    end
  end

  # delete a node od an app
  delete "/node/:username/:app_name/:node_addr/?" do
    username = params[:username]
    app_name = params[:app_name]
    node_addr = params[:node_addr]
    begin
      db = SQLite3::Database.open "./db/loramns.db"
      db.execute "DELETE FROM Nodes WHERE username=? AND app_name=? AND node_addr=?", username, app_name, node_addr
    rescue SQLite3::Exception => e
      puts "Exception occurred"
      puts e
      halt 404, "LoRaWAN Node (app_name: #{app_name}) cannot be deleted!"
    ensure
      db.close if db
    end
  end
end
