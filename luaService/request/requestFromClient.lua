local REQUEST = {}

function REQUEST:say()
    print("say", self.name, self.msg)
	return {name = "cxk", msg = "hello"}		
end

function REQUEST:handshake()
    print("handshake")
end

function REQUEST:quit()
    print("quit")	
end
