# frozen_string_literal: true
class LORAWAN_NMS_API < Sinatra::Base

  # get all applications of a user from DB
  get "/app/?" do
    username = params[:username]
    begin
      content_type 'application/json'
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

  # create an application into DB
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

  # post "/app/?" do
  #   username = params[:username]
  #   app_name = params[:app_name]
  #   app_description = params[:app_description]
  #   begin
  #     applications = DB[:applications] # Create a dataset
  #     applications.insert(:username => username , :app_name => app_name, :app_description => app_description)
  #   rescue Sequel::Error => e
  #     p e.message
  #     halt 404, "LoRaWAN Applications (name: #{app_name}) cannot be created!"
  #   end
  # end

  # delete an application into DB
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

end
