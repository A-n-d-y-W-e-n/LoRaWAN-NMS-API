# frozen_string_literal: true
class LORAWAN_NMS_API < Sinatra::Base

  # get the application list of a user
  get "/app/?" do
    username = params[:username]
    begin
      content_type 'application/json'
      data=[]
      DB['SELECT * FROM Applications WHERE username = ? ORDER BY ID',username].each do |row|
        data << row
      end
      return data.to_json

    rescue Sequel::Error => e
      p e.message
      halt 404, "LoRaWAN Application List (username: #{username}) not found!"
    end
  end

  # create a new application
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

  # delete an application
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

  # count the number of nodes
  get "/app/node_number/?" do
    username = params[:username]
    app_name = params[:app_name]
    begin
      content_type 'application/json'
      data=[]
      DB['SELECT COUNT(app_name) FROM Nodes WHERE app_name=? AND username=?',app_name,username].each do |row|
        data << row
      end
      return data.to_json
    rescue Sequel::Error => e
      p e.message
      halt 404, "LoRaWAN Application Nodes (name: #{app_name}) cannot be counted!"
    end
  end
end
