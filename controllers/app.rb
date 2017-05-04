# frozen_string_literal: true
class LORAWAN_NMS_API < Sinatra::Base

  # create an application into DB
  post "/app/:username/:app_name/:app_description/?" do
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

  # get all applications of a user from DB
  get "/app/:username/?" do
    username = params[:username]
    begin
      content_type 'application/json'
      data=[]
      db = SQLite3::Database.open "./db/loramns.db"
      db.execute "SELECT app_name FROM Applications WHERE username = ?",username do |row|
        data << row.to_json
      end
      return data
    rescue SQLite3::Exception => e
      puts "Exception occurred"
      puts e
      halt 404, "LoRaWAN Application (username: #{username}) not found!"
    ensure
      db.close if db
    end
  end
end
