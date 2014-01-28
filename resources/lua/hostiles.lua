hostile = {}
hostile.__index = hostile
hostile.timer = 0
hostile.genDelay = 2

hostile.hostiles = {}

function hostile.create(d, r)
	h = {}
	setmetatable(h, hostile)
	h.x = 0
	h.y = 0
	h.r = math.rad(r*10)
	h.dist = d
	h.offset = {
		x = love.window.getWidth()/2,
		y = love.window.getHeight()/2
	}
	h.size = 50
	h.rSpd = 45
	h.dSpd = 10
	h.direction = "in"

	return h
end

function hostile.generate(dt)
	if #hostile.hostiles < 10 then
		if hostile.timer < hostile.genDelay then
			hostile.timer = hostile.timer + dt
		else
			table.insert(hostile.hostiles, hostile.create(math.random(150, 350), math.rad(math.random(0, 36)), math.random(1, 2)))
			hostile.timer = 0
		end
	end
end

function hostile:update(dt)
	if self.r > math.rad(360) then
		self.r = 0
	else
		self.r = self.r + math.rad(self.rSpd)*dt
	end

	if self.direction == "in" then
		if self.dist < 150 then
			self.direction = "out"
		else
			self.dist = self.dist - self.dSpd*dt
		end
	elseif self.direction == "out" then
		if self.dist > 350 then
			self.direction = "in"
		else
			self.dist = self.dist + self.dSpd*dt
		end
	end

	self.x = self.offset.x + self.dist*math.cos(self.r-math.rad(90))
	self.y = self.offset.y + self.dist*math.sin(self.r-math.rad(90))
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