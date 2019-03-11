 local socket = require("socket.core")
 local udp = socket.udp()
 local host = host or '127.0.0.1'
 local port = '8001'
 udp:settimeout(4)
 function rec_msg()
     local recudp = udp:receive()
     if(recudp) then
         print('recudp data:'..recudp)
     else
         print('recudp data nil')
     end
 end
 while 1 do
     udp:setpeername(host, port)
     local udpsend = udp:send('hello 111111111')
     if(udpsend) then
         print('udpsend ok')
         rec_msg()
         break
     else
        print('udpsend err')
     end
 end
 udp:close()