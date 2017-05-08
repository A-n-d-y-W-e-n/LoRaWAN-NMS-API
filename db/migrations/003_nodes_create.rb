# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:nodes) do
      primary_key :id
      String :username
      String :app_name
      String :node_addr
      
      unique [:node_addr]
    end
  end
end
