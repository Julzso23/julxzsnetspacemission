projectile = {}
projectile.__index = projectile

projectile.projectiles = {}

function projectile.create(x, y, r, col)
	local p = {}
	setmetatable(p, projectile)
	p.x = x
	p.y = y
	p.r = r
	p.spd = 400
	p.len = 5
	p.colour = col
	
	return p
end

function projectile:update(dt, k)
	self.x = self.x + self.spd*math.cos(self.r-math.rad(90))*dt
	self.y = self.y + self.spd*math.sin(self.r-math.rad(90))*dt

	if self.x < 0 or self.x > love.window.getWidth() or self.y < 0 or self.y > love.window.getHeight() then
		table.remove(projectile.projectiles, k)
	end
end

function projectile:draw()
	love.graphics.setColor(self.colour)
	love.graphics.line(self.x, self.y, self.x-self.len*math.cos(self.r-math.rad(90)), self.y-self.len*math.sin(self.r-math.rad(90)))
end