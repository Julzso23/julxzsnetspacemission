player = {}
player.__index = player
player.timer = 0
player.fireDelay = 0.2

local mp = require("resources/lib/MessagePack")

function player.create()
	local p = {}
	setmetatable(p, player)
	p.x = love.window.getWidth()/2
	p.y = love.window.getHeight()/2
	p.r = 0
	p.spd = 200
	p.img = love.graphics.newImage("resources/images/playerSprite.png")
	
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

function player:fire()
	if self.timer >= self.fireDelay then
		self.timer = 0
		table.insert(projectile.projectiles, projectile.create(self.x+math.cos(self.r-math.rad(90)), self.y+math.sin(self.r-math.rad(90)), self.r))
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