# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      String :username, :null=>false
      String :user_email, :null=>false
      String :password, :null=>false

      unique [:username, :user_email]
    end
  end
end
