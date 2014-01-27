function love.load()
	for k, v in pairs(love.filesystem.getDirectoryItems("resources/lua")) do
		if not(v == "LUBE.lua") then
			require("resources/lua/"..string.gsub(v, ".lua", ""))
			print("Included "..v)
		end
	end

	joysticks = love.joystick.getJoysticks()
	
	ply = player.create()
end

function love.update(dt)
	if joysticks[1]:getGamepadAxis("leftx") < -0.2 or joysticks[1]:getGamepadAxis("leftx") > 0.2 or joysticks[1]:getGamepadAxis("lefty") < -0.2 or joysticks[1]:getGamepadAxis("lefty") > 0.2 then
		ply:move(joysticks[1]:getGamepadAxis("leftx"), joysticks[1]:getGamepadAxis("lefty"), dt)
	end

	for k, v in pairs(projectile.projectiles) do
		v:update(dt, k)
	end

	spaceParticle.generate(dt)
	hostile.generate(dt)

	for k, v in pairs(spaceParticle.particles) do
		v:update(dt, k)
	end
	for k, v in pairs(hostile.hostiles) do
		v:update(dt)
		v:checkCollisions(projectile.projectiles, k)
	end
end

function love.draw()
	for k, v in pairs(spaceParticle.particles) do
		v:draw()
	end

	for k, v in pairs(projectile.projectiles) do
		v:draw()
	end

	ply:draw()

	for k, v in pairs(hostile.hostiles) do
		v:draw()
	end
end

function love.gamepadpressed(joystick, button)
	ply:gamepadpressed(joystick, button)
end