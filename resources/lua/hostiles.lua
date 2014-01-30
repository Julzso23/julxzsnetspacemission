hostile = {}
hostile.__index = hostile
hostile.timer = 0
hostile.genDelay = 2

hostile.hostiles = {}
hostile.projectiles = {}

function hostile.create(x, r)
	h = {}
	setmetatable(h, hostile)
	h.x = x
	h.y = 0
	h.r = math.rad(r+100)
	h.size = 50
	h.spd = 200
	h.timer = 0.4
	h.fireDelay = 1

	return h
end

function hostile.generate(dt)
	if #hostile.hostiles < 10 then
		if hostile.timer < hostile.genDelay then
			hostile.timer = hostile.timer + dt
		else
			table.insert(hostile.hostiles, hostile.create(math.random(love.window.getWidth()), math.random(160)))
			hostile.timer = 0
		end
	end
end

function hostile:update(dt, key, player)
	if self.timer < self.fireDelay then
		self.timer = self.timer + dt
	else
		table.insert(hostile.projectiles, projectile.create(self.x, self.y, math.atan2(player.y-self.y, player.x-self.x)+math.rad(math.random(82, 98)), 250, {255, 100, 100, 255}))
		self.timer = 0
	end

	self.x = self.x + self.spd*math.cos(self.r-math.rad(90))*dt
	self.y = self.y + self.spd*math.sin(self.r-math.rad(90))*dt

	if self.x < -10 or self.x > love.window.getWidth()+10 or self.y < -10 or self.y > love.window.getHeight()+10 then
		table.remove(hostile.hostiles, key)
	end
end

function hostile:draw()
	love.graphics.setColor(100, 100, 255, 255)
	love.graphics.rectangle("fill", self.x-self.size/2, self.y-self.size/2, self.size, self.size)
end

function hostile:checkCollisions(obj, key)
	for k, v in pairs(obj) do
		if v.x > self.x-self.size/2 and v.x < self.x+self.size/2 and v.y > self.y-self.size/2 and v.y < self.y+self.size/2 then
			table.remove(hostile.hostiles, key)
			table.remove(obj, k)
		end
	end
end