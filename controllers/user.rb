# frozen_string_literal: true
class LORAWAN_NMS_API < Sinatra::Base

  # get the user info from DB
  get "/user/?" do
    username = params[:username]
    begin
      content_type 'application/json'
      data=[]
      DB['SELECT * FROM Users WHERE username = ?',username].each do |row|
        data << row
      end
      return data.to_json
    rescue Sequel::Error => e
      p e.message
      halt 404, "LoRaWAN User (username: #{:username}) not found!"
    end
  end

  # insert the user info into DB
  post "/create_user/?" do
    username = params[:username]
    user_email = params[:user_email]
    password = params[:password]
    begin
      DB[:users].insert(:username => username , :user_email => user_email, :password => password)
      halt 200, "LoRaWAN User (username: #{username}) was created!"
    rescue Sequel::Error => e
      p e.message
      halt 404, "LoRaWAN User (username: #{username}) cannot be created!"
    end
  end

end
