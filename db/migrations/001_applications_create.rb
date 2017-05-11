# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:applications) do
      primary_key :id
      String :username, :null=>false
      String :app_name, :null=>false
      String :app_description

      unique [:username, :app_name]
    end
  end
end
