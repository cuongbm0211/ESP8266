-- initiate the mqtt client and set keepalive timer to 120sec
mqtt = mqtt.Client("client_id", 120, "", "")

mqtt:on("connect", function(con) print ("connected") end)
-- mqtt:on("offline", function(con) print ("offline") end)
mqtt:on("offline", function(con) 
     print ("reconnecting...") 
     print(node.heap())
     tmr.alarm(1, 10000, 0, function()
          mqtt:connect("192.168.1.68", 1883, 0)
     end)
end)

-- on receive message
mqtt:on("message", function(conn, topic, data)
  print(topic .. ":" )
  if data ~= nil then
    print(data)
  end
end)

mqtt:connect("192.168.1.68", 1883, 0, function(conn) 
  print("connected")
  -- subscribe topic with qos = 0
  mqtt:subscribe("/topic",0, function(conn) 
    -- publish a message with data = my_message, QoS = 0, retain = 0
    mqtt:publish("/topic","hello",0,0, function(conn) 
      print("sent") 
    end)
  end)
end)