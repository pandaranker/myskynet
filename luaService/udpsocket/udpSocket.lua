local skynet = require "skynet"
local socket = require "skynet.socket"

local function server()
	local host
	host = socket.udp(function(str, from)
		print("server recv", str, socket.udp_address(from))
		socket.sendto(host, from, "OK " .. str)
	end , "0.0.0.0", 8001)	-- bind an address
end

skynet.start(function()
	skynet.fork(server)
end)
