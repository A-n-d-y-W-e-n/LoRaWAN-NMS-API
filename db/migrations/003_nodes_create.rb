# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:nodes) do
      primary_key :id
      String :username, :null=>false
      String :app_name, :null=>false
      String :node_addr, :null=>false
      String :node_nwkskey, :null=>false
      String :node_appskey, :null=>false
      
      unique [:node_addr]
    end
  end
end
