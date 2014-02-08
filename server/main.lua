require("resources/lua/hook")

function love.load()
	for k, v in pairs(love.filesystem.getDirectoryItems("resources/lua")) do
		require("resources/lua/"..string.gsub(v, ".lua", ""))
	end
	hook.Call("load")
end

function love.update(dt) hook.Call("update", dt) end

function love.draw() hook.Call("draw") end

function love.keypressed(key, isRepeat) hook.Call("keypressed", key, isRepeat) end

function love.keyreleased(key) hook.Call("keyreleased", key) end

function love.gamepadpressed(joystick, button) hook.Call("gamepadpressed", joystick, button) end

function love.gamepadreleased(joystick, button) hook.Call("gamepadreleased", joystick, button) end

function love.gamepadaxis(joystick, axis) hook.Call("gamepadaxis", joystick, axis) end

function love.mousepressed(x, y, button) hook.Call("mousepressed", x, y, button) end

function love.mousereleased(x, y, button) hook.Call("mousereleased", x, y, button) end

function love.joystickadded(joystick) hook.Call("joystickadded", joystick) end

function love.joystickremoved(joystick) hook.Call("joystickremoved", joystick) end

function love.quit() hook.Call("quit") end