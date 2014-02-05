local commands = {
	{"connect", function(dat, ip)
		print(ip.."connected")
		table.insert(player.players, {ip, player.create()})
	end},
	{"update", function(dat, ip)
		for k, v in pairs(player.players) do
			if v[1] == ip then
				v[2].x = dat.x
				v[2].y = dat.y
				v[2].r = dat.r
			end
		end
	end},
	{"fire", function(dat, ip)
		for k, v in pairs(player.players) do
			if ip == v[1] then
				table.insert(player.projectiles, projectile.create(v[2].x+math.cos(v[2].r-math.rad(90)), v[2].y+math.sin(v[2].r-math.rad(90)), v[2].r, 400, {100, 255, 100, 255}))
			end
		end
	end}
}

hook.Add("load", "setupServer", function()
	socket = require("socket")
	msgp = require("resources/lib/MessagePack")
	udp = socket.udp()
	udp:settimeout(0)
	udp:setsockname("*", 9001)
end)

hook.Add("update", "NWMessageHandler", function(dt)
	local data, msg, port = udp:receivefrom()
	if data then
		local d = msgp.unpack(data)

		for _, c in pairs(commands) do
			if d[1] == c[1] then
				c[2](d[2], msg)
			end
		end

		udp:sendto(data, msg, port)
	elseif msg == "timout" then
		error("Network error: "..tostring(msg))
	end
end)