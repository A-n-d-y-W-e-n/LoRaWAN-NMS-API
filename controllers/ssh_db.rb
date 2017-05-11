# frozen_string_literal: true
class LORAWAN_NMS_API < Sinatra::Base

  # insert the key of the node into gateway DB
  post "/add_node/abp/?" do
    @hostname = '192.168.88.1'
    @username = 'root'
    @password = 'gemtek'
    DevAddr = params[:DevAddr]
    NwkSKey = params[:NwkSKey]
    AppSKey = params[:AppSKey]
    begin
      ssh = Net::SSH.start(@hostname, @username, :password => @password)
      res = ssh.exec!("sqlite3 /app/db/lora.db \
                       \"INSERT INTO table_abp VALUES ( \'#{DevAddr}\', \'#{NwkSKey}\', \'#{AppSKey}\' );\"
                      ")
      ssh.close
      puts res
    rescue
      halt 404, "Unable to connect to #{@hostname} using #{@username}/#{@password}!"
    end
  end

  # delete the key of the node from gateway DB
  post "/delete_node/abp/?" do
    @hostname = '192.168.88.1'
    @username = 'root'
    @password = 'gemtek'
    DevAddr = params[:DevAddr]
    begin
      ssh = Net::SSH.start(@hostname, @username, :password => @password)
      res = ssh.exec!("sqlite3 /app/db/lora.db \
                       \"DELETE FROM table_abp WHERE devaddr= \'#{DevAddr}\' ;\"
                      ")
      ssh.close
      puts res
    rescue
      halt 404, "Unable to connect to #{@hostname} using #{@username}/#{@password}!"
    end
  end

end
