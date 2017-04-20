# frozen_string_literal: true

require 'rubygems'
require 'net/ssh'

@hostname = '192.168.88.1'
@username = 'root'
@password = 'gemtek'

# node_info = {
#   "DevAddr" => "cccccccc",
#   "NwkSKey" => "cccccccccccccccccccccccccccccccc",
#   "AppSKey" => "cccccccccccccccccccccccccccccccc"
# }

DevAddr = 'aaaaaaaa'
NwkSKey = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
AppSKey = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'

begin
  ssh = Net::SSH.start(@hostname, @username, :password => @password)

  res = ssh.exec!("sqlite3 /app/db/lora.db \
                   \"INSERT INTO table_abp VALUES ( \'#{DevAddr}\', \'#{NwkSKey}\', \'#{AppSKey}\' );\"
                  ")

  ssh.close
  puts res
rescue
  puts "Unable to connect to #{@hostname} using #{@username}/#{@password}"
end
