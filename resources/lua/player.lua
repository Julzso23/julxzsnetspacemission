player = {}
player.__index = player

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

	print(p.health)
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
	print(self.health)
end

function player:fire()
	if self.timer >= self.fireDelay then
		table.insert(player.projectiles, projectile.create(self.x+math.cos(self.r-math.rad(90)), self.y+math.sin(self.r-math.rad(90)), self.r, {100, 255, 100, 255}))
		self.timer = 0
	end
end

function player:save()
	love.filesystem.write("test.txt", mp.pack({
		x=self.x,
		y=self.y,
		r=self.r
	}))
end
function player:load()
	local data = love.filesystem.read("test.txt")
	data = mp.unpack(data)
	self.x = data.x
	self.y = data.y
	self.r = data.r
end