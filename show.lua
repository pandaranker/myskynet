--获取c2s协议数据
local sprotoparser = require "sprotoparser"
local proto = {}
proto.c2s = sprotoparser.parse(require "c2s")
return proto
--解析收到的socket数据并分发
host = sproto.new(proto.c2s):host "package"
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
end
--以下为REQUEST处理函数
local REQUEST = {}
function REQUEST:handshake()
    print("handshake")
end
return REQUEST


