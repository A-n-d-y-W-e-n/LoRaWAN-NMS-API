# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:gateways) do
      primary_key :id
      String :gateway_name, :null=>false
      String :gateway_mac, :null=>false
      String :gateway_ip, :null=>false
      String :gateway_loc, :null=>false

      unique [:gateway_name, :gateway_mac, :gateway_ip]
    end
  end
end
