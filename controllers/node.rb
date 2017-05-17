# frozen_string_literal: true
class LORAWAN_NMS_API < Sinatra::Base

  # get all nodes of an application of a user from DB
  get "/node/?" do
    username = params[:username]
    app_name = params[:app_name]
    begin
      content_type 'application/json'
      data=[]
      DB["SELECT * FROM Nodes WHERE username = ? AND app_name = ? ORDER BY id",username, app_name].each do |row|
        data << row
      end
      puts data.to_json.length
      return data.to_json
    rescue Sequel::Error => e
      p e.message
      halt 404, "LoRaWAN Node (username: #{username}, app_name:#{app_name}) not found!"
    end
  end

  # get the last received data of a node from DB
  get "/node_data/?" do
    node_addr = '00000000' + params[:node_addr]
    puts node_addr
    begin
      content_type 'application/json'
      data=[]
      DB["SELECT * FROM Nodes_data WHERE macAddr = ? ORDER BY ID DESC LIMIT 1",node_addr].each do |row|
        data << row
      end
      return data.to_json
    rescue Sequel::Error => e
      p e.message
      halt 404, "LoRaWAN Node Data (address: #{:node_addr}) not found!"
    end
  end

  # insert the info of a node into DB
  post "/add_node/?" do
    username = params[:username]
    app_name = params[:app_name]
    node_addr = params[:node_addr]
    node_nwkskey = params[:node_nwkskey]
    node_appskey = params[:node_appskey]
    begin
      DB[:nodes].insert(:username => username , :app_name => app_name, :node_addr => node_addr, :node_nwkskey => node_nwkskey, :node_appskey => node_appskey)
      halt 200, "LoRaWAN Node (app_name: #{app_name}) was created!"
    rescue Sequel::Error => e
      p e.message
      halt 404, "LoRaWAN Node (app_name: #{app_name}) cannot be created!"
    end
  end

  # delete a node of an app
  post "/delete_node/?" do
    username = params[:username]
    app_name = params[:app_name]
    node_addr = params[:node_addr]
    begin
      DB[:nodes].where(:username=>username, :app_name=>app_name, :node_addr=>node_addr).delete
      halt 200, "LoRaWAN Node (app_name: #{app_name}) was deleted!"
    rescue Sequel::Error => e
      p e.message
      halt 404, "LoRaWAN Node (app_name: #{app_name}) cannot be deleted!"
    end
  end

end
