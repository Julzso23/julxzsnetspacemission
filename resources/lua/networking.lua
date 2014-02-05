local socket = require("socket")
local msgp = require("resources/lib/MessagePack")
local address, port = "localhost", 9001

net = {}
net.udp = socket.udp()

hook.Add("load", "netConnect", function()
	net.udp:settimeout(0)
	net.udp:setpeername(address, port)
	net.udp:send(msgp.pack({"connect"}))
end)

hook.Add("update", "netUpdate", function(dt)
	local dat = {"update", {x=player.players[1].x, y=player.players[1].y, r=player.players[1].r}
}
	local data, msg = net.udp:receive()
	if data then
		local d = msgp.unpack(data)
		if d == "connect" then
			print("Connected successfully")
		end
		net.udp:send(msgp.pack(dat))
	elseif msg == "timout" then
		error("Network error: "..tostring(msg))
	end
end)

function net.send(data)
	net.udp:send(msgp.pack({data}))
end