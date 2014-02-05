player = {}
player.__index = player

player.players = {}
player.projectiles = {}

local mp = require("resources/lib/MessagePack")

function player.create()
	local p = {}
	setmetatable(p, player)
	p.x = love.window.getWidth()/2
	p.y = love.window.getHeight()/2
	p.r = 0
	p.spd = 200
	p.img = love.graphics.newImage("resources/images/playerSprite.png")
	p.timer = 0
	p.fireDelay = 0.2
	p.health = 100

	return p
end

function player:move(x, y, dt)
	self.x = self.x + x*self.spd*dt
	self.y = self.y + y*self.spd*dt
	self.r = math.atan2(-x, y)+math.rad(180)
end

function player:draw()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.img, self.x, self.y, self.r, 0.5, 0.5, self.img:getWidth()/2, self.img:getHeight()/2)
end

function player:update(dt)
	if self.timer < self.fireDelay then
		self.timer = self.timer + dt
	end
	if self.health < 100 then
		self.health = self.health + 2*dt
	end
end

function player:checkCollisions(obj)
	for k, v in pairs(obj) do
		if v.x > self.x-self.img:getWidth()/3 and v.x < self.x+self.img:getWidth()/3 and v.y > self.y-self.img:getHeight()/3 and v.y < self.y+self.img:getHeight()/3 then
			table.remove(obj, k)
			self:onHit()
		end
	end
end

function player:onHit()
	if self.health >= 10 then
		self.health = self.health - 10
	else
		self.health = 0
	end
end

function player:fire()
	if self.timer >= self.fireDelay then
		table.insert(player.projectiles, projectile.create(self.x+math.cos(self.r-math.rad(90)), self.y+math.sin(self.r-math.rad(90)), self.r, 400, {100, 255, 100, 255}))
		net.send("fire")
		self.timer = 0
	end
end

hook.Add("load", "addPlayer", function()
	joysticks = love.joystick.getJoysticks()
	table.insert(player.players, player.create())
end)

hook.Add("update", "playerUpdate", function(dt)
	for k, v in pairs(player.players) do
		v:update(dt)
		v:checkCollisions(hostile.projectiles)
	end

	for k, v in pairs(player.projectiles) do
		v:update(dt, k)
	end

	if #joysticks >= 1 then
		if joysticks[1]:getGamepadAxis("leftx") < -0.2 or joysticks[1]:getGamepadAxis("leftx") > 0.2 or joysticks[1]:getGamepadAxis("lefty") < -0.2 or joysticks[1]:getGamepadAxis("lefty") > 0.2 then
			player.players[1]:move(joysticks[1]:getGamepadAxis("leftx"), joysticks[1]:getGamepadAxis("lefty"), dt)
		end
		if joysticks[1]:getGamepadAxis("triggerright") > 0.5 then
			player.players[1]:fire()
		end
	end
end)

hook.Add("draw", "playerDraw", function()
	for k, v in pairs(player.projectiles) do
		v:draw()
	end
	
	for k, v in pairs(player.players) do
		v:draw()
	end
end)

hook.Add("gamepadpressed", "playerControls", function(joystick, button)
	if button == "start" then
		player.players[1]:save()
	end
	if button == "back" then
		player.players[1]:load()
	end
end)