spaceParticle = {}
spaceParticle.__index = spaceParticle
spaceParticle.timer = 0
spaceParticle.genDelay = 0.1

spaceParticle.particles = {}

function spaceParticle.create(x, r, s)
	p = {}
	setmetatable(p, spaceParticle)
	p.x = x
	p.y = 0
	p.r = r
	p.size = s
	p.spd = 200

	return p
end

function spaceParticle.generate(dt)
	if spaceParticle.timer < spaceParticle.genDelay then
		spaceParticle.timer = spaceParticle.timer + dt
	else
		table.insert(spaceParticle.particles, spaceParticle.create(math.random(love.window.getWidth()), math.rad(math.random(135, 225)), math.random(1, 2)))
		spaceParticle.timer = 0
	end
end

function spaceParticle:update(dt, key)
	self.x = self.x + self.spd*math.cos(self.r-math.rad(90))*dt
	self.y = self.y + self.spd*math.sin(self.r-math.rad(90))*dt

	if self.x > love.window.getWidth() or self.y < 0 or self.y > love.window.getHeight() then
		table.remove(spaceParticle.particles, key)
	end
end

function spaceParticle:draw()
	love.graphics.setColor(255, 255, 255, 150)
	love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
end