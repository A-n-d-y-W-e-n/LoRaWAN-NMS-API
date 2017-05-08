# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:applications) do
      primary_key :id
      String :username
      String :app_name
      String :app_description

      unique [:app_name]
    end
  end
end
