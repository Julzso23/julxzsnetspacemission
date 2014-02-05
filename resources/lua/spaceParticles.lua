spaceParticle = {}
spaceParticle.__index = spaceParticle
spaceParticle.limit = 150

spaceParticle.particles = {}

function spaceParticle.create(x, y, s)
	p = {}
	setmetatable(p, spaceParticle)
	p.ox = x
	p.oy = y
	p.x = 0
	p.y = 0
	p.size = s
	p.spd = 100

	return p
end

function spaceParticle.generate()
	local i = 0
	while i < spaceParticle.limit do
		table.insert(spaceParticle.particles, spaceParticle.create(math.random(-10, love.window.getWidth()+10), math.random(-10, love.window.getHeight()+10), math.random(1, 2)))
		i = i + 1
	end
end

function spaceParticle:update(dt, player)
	self.x = self.ox + player.x/15
	self.y = self.oy + player.y/15
end

function spaceParticle:draw()
	love.graphics.setColor(255, 255, 255, 150)
	love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
end

hook.Add("load", "generateSpaceParticles", function()
	spaceParticle.generate()
end)

hook.Add("update", "updateSpaceParticles", function(dt)
	for k, v in pairs(spaceParticle.particles) do
		v:update(dt, player.players[1])
	end
end)

hook.Add("draw", "drawSpaceParticles", function()
	for k, v in pairs(spaceParticle.particles) do
		v:draw()
	end
end)