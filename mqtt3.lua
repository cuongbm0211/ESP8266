m = mqtt.Client(wifi.sta.getmac(), 120, "", "")
m:lwt("/lwt", wifi.sta.getmac(), 0, 0)

m:on("offline", function(con) 
     print ("reconnecting...") 
     print(node.heap())
     tmr.alarm(1, 10000, 0, function()
          m:connect("192.168.1.68", 1880, 0)
     end)
end)

-- on publish message receive event
m:on("message", function(conn, topic, data) 
  print(topic .. ":" ) 
  if data ~= nil then
    print(data)
  end
end)

tmr.alarm(0, 1000, 1, function()
 if wifi.sta.status() == 5 then
     tmr.stop(0)
     m:connect("192.168.11.102", 1880, 0, function(conn) 
          print("connected")
          m:subscribe("/topic",0, function(conn) 
               m:publish("/topic","hello",0,0, function(conn) print("sent") end)
          end)
     end)
 end
end)