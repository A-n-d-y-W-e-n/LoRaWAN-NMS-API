# frozen_string_literal: true

require 'rubygems'
require 'mqtt'
require 'json'
require 'sqlite3'

GW_MAC = "1C497B4989A8"
route = []

connect_info = {
  :host => "104.199.215.165",
  :port => 1883,
  :username => "admin",
  :password => "admin",
  :client_id => "123",
  :keep_alive => 60,
}

def insert_node_data_and_find_route(data)
  begin
    db = SQLite3::Database.open "db/loramns.db"
    db.execute "CREATE TABLE IF NOT EXISTS Nodes_data (ID INTEGER PRIMARY KEY AUTOINCREMENT,
                                                  channel INT,
                                                  sf INT,
                                                  time TEXT,
                                                  gwip TEXT,
                                                  gwid TEXT,
                                                  repeater TEXT,
                                                  systype INT,
                                                  rssi REAL,
                                                  snr REAL,
                                                  snr_max REAL,
                                                  snr_min REAL,
                                                  macAddr TEXT,
                                                  data TEXT,
                                                  frameCnt INT,
                                                  fport INT
                                                  )"
    db.execute "INSERT INTO Nodes_data VALUES(null,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", data[0]['channel'], data[0]['sf'], data[0]['time'], data[0]['gwip'], data[0]['gwid'], data[0]['repeater'], data[0]['systype'], data[0]['rssi'],
      data[0]['snr'], data[0]['snr_max'], data[0]['snr_min'], data[0]['macAddr'], data[0]['data'], data[0]['frameCnt'], data[0]['fport']
    db.execute "SELECT * FROM Nodes WHERE node_addr = ? ",data[0]['macAddr'][8,16] do |row|
      puts row
      return row
    end
  rescue SQLite3::Exception => e
    puts "Exception occurred"
    puts e
  ensure
    db.close if db
  end
end

MQTT::Client.connect(connect_info) do |c|
  c.get("GIOT-GW/UL/#{GW_MAC}") do |topic,message|
    # Block is executed for every message received
    message_json = JSON.parse(message)
    route = insert_node_data_and_find_route(message_json)
    puts "#{topic} = #{message}"
    c.publish( route[1] + "/" + route[2] + "/" + route[3], message)
  end
end
