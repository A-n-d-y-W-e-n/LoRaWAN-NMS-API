# frozen_string_literal: true
class LORAWAN_NMS_API < Sinatra::Base

  # get the gateway list
  get "/gateway/?" do
    begin
      content_type 'application/json'
      data=[]
      DB['SELECT * FROM Gateways ORDER BY ID'].each do |row|
        data << row
      end
      return data.to_json
    rescue Sequel::Error => e
      p e.message
      halt 404, "LoRaWAN Gateway List not found!"
    end
  end

  # add a new gateway
  post "/add_gateway/?" do
    gateway_name = params[:gateway_name]
    gateway_mac = params[:gateway_mac]
    gateway_ip = params[:gateway_ip]
    gateway_loc = params[:gateway_loc]
    gateway_username = params[:gateway_username]
    begin
      DB[:gateways].insert(:gateway_name => gateway_name , :gateway_mac => gateway_mac , :gateway_ip => gateway_ip , :gateway_loc => gateway_loc , :username => gateway_username)
      halt 200, "LoRaWAN Gateway (name: #{gateway_name}) was created!"
    rescue Sequel::Error => e
      p e.message
      halt 404, "LoRaWAN Gateway (name: #{gateway_name}) cannot be created!"
    end
  end

  # delete the gateway info from DB
  post "/delete_gateway/?" do
    gateway_mac = params[:gateway_mac]
    begin
      DB[:gateways].where(:gateway_mac => gateway_mac).delete
      halt 200, "LoRaWAN Gateway (name: #{gateway_mac}) was deleted!"
    rescue Sequel::Error => e
      p e.message
      halt 404, "LoRaWAN Gateway (name: #{gateway_mac}) cannot be deleted!"
    end
  end

  # get gateway log
  get "/gateway_log/?" do
    gateway_ip = params[:gateway_ip]
    begin
      content_type 'application/json'
      data=[]
      DB["SELECT MIN(rssi), MIN(snr) FROM Nodes_data WHERE gwip = ?",gateway_ip].each do |row|
        data << row
      end
      return data.to_json
    rescue Sequel::Error => e
      p e.message
      halt 404, "LoRaWAN Gateway Log (address: #{gateway_ip}) not found!"
    end
  end

end
