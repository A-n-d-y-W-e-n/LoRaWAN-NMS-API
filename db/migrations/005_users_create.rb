# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:nodes) do
      primary_key :id

    end
  end
end
