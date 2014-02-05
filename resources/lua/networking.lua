local socket = require("socket")
local msgp = require("resources/lib/MessagePack")
local address, port = "localhost", 9001

networking = {}
networking.udp = socket.udp()

hook.Add("load", "networkConnect", function()
	networking.udp:settimeout(0)
	networking.udp:setpeername(address, port)

	networking.udp:send(msgp.pack("connect"))
end)

hook.Add("update", "networkUpdate", function(dt)
	networking.data = {x=player.players[1].x, y=player.players[1].y, r=player.players[1].r}

	local data, msg = networking.udp:receive()
	if data then
		local d = msgp.unpack(data)
		if d == "connect" then
			print("Connected successfully")
		end
		networking.udp:send(msgp.pack(networking.data))
	elseif msg == "timout" then
		error("Network error: "..tostring(msg))
	end
end)