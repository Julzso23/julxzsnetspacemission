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
		self.timer = 0
	end
end

hook.Add("update", "playerUpdate", function(dt)
	for k, v in pairs(player.players) do
		v[2]:update(dt)
		v[2]:checkCollisions(hostile.projectiles)
	end

	for k, v in pairs(player.projectiles) do
		v:update(dt, k)
	end
end)

hook.Add("draw", "playerDraw", function()
	for k, v in pairs(player.projectiles) do
		v[2]:draw()
	end
	
	for k, v in pairs(player.players) do
		v[2]:draw()
	end
end)