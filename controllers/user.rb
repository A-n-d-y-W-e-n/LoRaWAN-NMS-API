# frozen_string_literal: true
class LORAWAN_NMS_API < Sinatra::Base

  # get the user info from DB
  get "/user/:username/?" do
    username = params[:username]
    begin
      content_type 'application/json'
      data=[]
      db = SQLite3::Database.open "./db/loramns.db"
      db.execute "SELECT password FROM Users WHERE username = ? ",username do |row|
        data << row.to_json
      end
      return data
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
