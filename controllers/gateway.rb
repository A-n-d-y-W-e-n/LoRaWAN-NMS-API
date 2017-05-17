# frozen_string_literal: true
class LORAWAN_NMS_API < Sinatra::Base

  # get the gateway info from gateway DB
  get "/gateway/?" do
    begin
      content_type 'application/json'
      data=[]
      DB['SELECT * FROM Gateways ORDER BY id'].each do |row|
        data << row
      end
      return data.to_json
    rescue Sequel::Error => e
      p e.message
      halt 404, "LoRaWAN Gateway List not found!"
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

end
