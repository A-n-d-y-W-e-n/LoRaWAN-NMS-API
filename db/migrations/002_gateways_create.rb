# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:gateways) do
      primary_key :id
      String :gateway_name
      String :gateway_mac
      String :gateway_ip
      String :gateway_loc
      
      unique [:gateway_name, :gateway_mac, :gateway_ip]
    end
  end
end
