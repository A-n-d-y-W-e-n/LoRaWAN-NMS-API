# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:nodes_data) do
      primary_key :id
      Integer :channel
      Integer :sf
      String :time
      String :gwip
      String :gwid
      String :repeater
      Integer :systype
      Float :rssi
      Float :snr
      Float :snr_max
      Float :snr_min
      String :macAddr
      String :data
      Integer :frameCnt
      Integer :fport
    end
  end
end
