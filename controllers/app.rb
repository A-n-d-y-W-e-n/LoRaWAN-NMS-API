# frozen_string_literal: true
class LORAWAN_NMS_API < Sinatra::Base

  # get all applications of a user from DB
  get "/app/?" do
    username = params[:username]
    begin
      content_type 'application/json'
      data=[]
      DB['SELECT * FROM Applications WHERE username = ? ORDER BY id',username].each do |row|
        data << row
      end
      return data.to_json

    rescue Sequel::Error => e
      p e.message
      halt 404, "LoRaWAN Application List (username: #{username}) not found!"
    end
  end

  # create an application into DB
  post "/create_app/?" do
    username = params[:username]
    app_name = params[:app_name]
    app_description = params[:app_description]
    begin
      DB[:applications].insert(:username => username , :app_name => app_name, :app_description => app_description)
      halt 200, "LoRaWAN Application (name: #{app_name}) was created!"
    rescue Sequel::Error => e
      p e.message
      halt 404, "LoRaWAN Application (name: #{app_name}) cannot be created!"
    end
  end

  # delete an application from DB
  post "/delete_app/?" do
    username = params[:username]
    app_name = params[:app_name]
    begin
      DB[:applications].where(:username=>username, :app_name=>app_name).delete
      halt 200, "LoRaWAN Application (name: #{app_name}) was deleted!"
    rescue Sequel::Error => e
      p e.message
      halt 404, "LoRaWAN Application (name: #{app_name}) cannot be deleted!"
    end
  end

end
