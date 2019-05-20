local skynet = require "skynet"
local socket = require "skynet.socket"

local proto = require "xjproto"
local sproto = require "sproto"

local REQUEST = require "requestFromClient"
require  "skynet.manager"
local mode , id = ...

local session = 0

LinkList = {}
local command = {name = 'ListDel'}

function command.del(id)
    LinkList[id]=nil
end

function send_request(name, args) 
	session = session + 1
	local str = requestSender(name, args, session)
	send_package(fd, str)
	print("Request:", session)
end

function command.gb(movement)
    send_request("player_movement",{id = movement.id,hor= movement.hor,ver = movement.ver})
end

local host
local last = ""

local function request(name, args, response)
    local f = assert(REQUEST[name])
    local r = f(args)
    if response and r then
        -- 生成回应包(response是一个用于生成回应包的函数。)
        -- 处理session对应问题
        return response(r)
    end

end

local function unpack_package(text)
	local size = #text
	if size < 2 then
		return nil, text
	end
	local s = text:byte(1) * 256 + text:byte(2)
	if size < s+2 then
		return nil, text
	end

	return text:sub(3,2+s), text:sub(3+s)
end

local function recv_package(last, fd)
	local result
	result, last = unpack_package(last)
	if result then
		return result, last
	end
	local r = socket.read(fd)
	if r then
		return nil, last .. r
	else
		return nil, nil
	end
end

local function send_package(id, pack)
	local package = string.pack(">s2", pack)
	socket.write(id, package) 
end

local function echo(id)
	socket.start(id)
    last = ""

    host = sproto.new(proto.c2s):host "package"
    --host2 = sproto.new(proto.s2c):host "package"
    requestSender = host:attach(sproto.new(proto.s2c))
	print("readline")
    print(id)

	while true do
		local str
        str, last = recv_package(last, id)
		if str then
			local type,str2,str3,str4 = host:dispatch(str)
			if type=="REQUEST" then
				local ok, result  = pcall(request,str2,str3,str4)
				if ok then
					if result then
						send_package(id,result)
					end
				else
					skynet.error(result)
				end
			end

			if str2 == "handshake" then
				print("握手信号")
				--socket.close(id)
				--return
			end

			if type=="RESPONSE" then
				-- 暂时不处理客户端的回应
				print("client response")
			end         
		elseif not last then
			print("disconnected!")
			socket.close(id)
            skynet.send('.socketmanager',"lua","del",id)
			return
		end
	end
end

if mode == "agent" then
	id = tonumber(id)
    skynet.register('.sonsocket')
    skynet.dispatch("lua", function(session, address, cmd, ...)
        local f = command[cmd]
        if f then
            f(...)
        else
            error(string.format("Unknown command %s", tostring(cmd)))
        end
    end)
	skynet.start(function()
		skynet.fork(function()
			echo(id)
			skynet.exit()
		end)
	end)
else
	local function accept(id)
		socket.start(id)
		socket.write(id, "Hello Skynet\n")
		skynet.newservice(SERVICE_NAME, "agent", id)
		socket.abandon(id)
	end
    
	skynet.start(function()
		local id = socket.listen("0.0.0.0", 8001)
		print("Listen socket :", "0.0.0.0", 8001)
		socket.start(id , function(id, addr)
			print("connect from " .. addr .. " " .. id)
			-- 1. skynet.newservice("testsocket", "agent", id)
			-- 2. skynet.fork(echo, id)
			-- 3. accept(id)
			LinkList[id]=addr
			for k, v in pairs(LinkList) do  
    		print(k, v)  
			end 
			accept(id)
		end)
        skynet.dispatch("lua", function(session, address, cmd, ...)
            local f = command[cmd]
            if f then
                f(...)
            else
                error(string.format("Unknown command %s", tostring(cmd)))
            end
        end)
	end)
    
end