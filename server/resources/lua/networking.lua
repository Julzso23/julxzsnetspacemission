hook.Add("load", "setupServer", function()
	socket = require("socket")
	msgp = require("resources/lib/MessagePack")
	udp = socket.udp()
	udp:settimeout(0)
	udp:setsockname("*", 9001)
end)

hook.Add("update", "updateClients", function(dt)
	local data, msg, port = udp:receivefrom()
	if data then
		local d = msgp.unpack(data)
		if d == "connect" then
			print(msg.." connected")
			table.insert(player.players, {msg, player.create()})
		else
			for k, v in pairs(player.players) do
				if v[1] == msg then
					v[2].x = d.x
					v[2].y = d.y
					v[2].r = d.r
				end
			end
		end
		udp:sendto(data, msg, port)
	elseif msg == "timout" then
		error("Network error: "..tostring(msg))
	end
end)