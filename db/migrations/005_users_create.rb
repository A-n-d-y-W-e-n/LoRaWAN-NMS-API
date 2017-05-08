# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      String :username
      String :user_email
      String :password
      
      unique [:username, :user_email]
    end
  end
end
