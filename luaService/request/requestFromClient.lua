local skynet = require "skynet"
local REQUEST = {}

REQUEST.playerList={}
REQUEST.playerPosition={}

function REQUEST:say()
    print("say", self.name, self.msg)
	return {name = "cxk", msg = "hello"}		
end

function REQUEST:player_join()
    print("玩家",self.name,"加入房间")
    REQUEST.playerList[self.id]=self.name
end

function REQUEST:handshake()
    print("handshake")
end

function REQUEST:quit()
    print("quit")	
end

function REQUEST:player_position()
    print(self.pos.id)	
    REQUEST.playerPosition[self.pos.id]=self
end

function REQUEST:player_movement()
    print(self.hor)
    skynet.send('.socketmanager',"lua","gb",self.id)
end

return REQUEST
