require("lua/actionStates/loadingScreen")
require("lua/controls/controls")

function love.load()
	local myFont = love.graphics.newImageFont("assets/fontBold.png", " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.,!?\'\"0123456789-+")
	love.graphics.setFont(myFont)

	controls = Controls()

	activeState = LoadingScreen()
	toState = nil
end

function love.draw()
	activeState:draw()

	if options and options.debug then
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.print(love.timer.getFPS(), 10, 10)
		love.graphics.print("Debug", 50, 10)
	end
end

--[[
	The root update handler. It dispatches update calls to the active state and
	any other module that cares about such things.
]]
function love.update(dt)
	if toState then
		activeState = toState
		toState = nil
	end
	activeState:update(dt)
end

function love.keypressed(key)
	if controls:isQuit(key) then
		love.event.push("quit")
		return
	end
	activeState:processControls(key)
end

function love.gamepadpressed(joystick, button)
	activeState:processControls(joystick, button)
end

function love.joystickaxis(joystick, axis, value)
	activeState:processControls(joystick, axis, value)
end


--[[
	Unused (?) input control hooks
]]
function love.keyreleased(key)
	activeState:keyreleased(key)
end

function love.mousepressed(x, y, button)
	activeState:mousepressed(x, y, button)
end

--[[
	The root collision handler. It dispatches collision handling to all other
	modules that care about such things.
]]
function beginContact(a, b, coll)
	if activeState.beginContact then
		activeState:beginContact(a, b, coll)
	elseif options.debug then
		error("Physics callback triggered from state without physics.")
	end
end
 
function endContact(a, b, coll)
	-- noop
end
 
function preSolve(a, b, coll)
	-- noop
end
 
function postSolve(a, b, coll, normalimpulse, tangentimpulse)
	 --noop
end
