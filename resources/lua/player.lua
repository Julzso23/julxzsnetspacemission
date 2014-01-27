player = {}
player.__index = player

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

function player:gamepadpressed(joystick, button)
	if button == "a" then
		table.insert(projectile.projectiles, projectile.create(self.x+math.cos(self.r-math.rad(90)), self.y+math.sin(self.r-math.rad(90)), self.r))
	end
end