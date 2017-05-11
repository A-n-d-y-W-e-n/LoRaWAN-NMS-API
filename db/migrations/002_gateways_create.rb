# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:gateways) do
      primary_key :id
      String :gateway_name, :null=>false, :unique=>true
      String :gateway_mac, :null=>false, :unique=>true
      String :gateway_ip, :null=>false, :unique=>true
      String :gateway_loc, :null=>false
      String :username, :null=>false
    end
  end
end
