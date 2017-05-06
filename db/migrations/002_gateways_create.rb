# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:gateways) do
      primary_key :id

    end
  end
end
