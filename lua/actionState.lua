require("lua/controls/controls")

ActionState = {}
ActionState.__index = ActionState

setmetatable(ActionState, {
	__index = ActionState,
	__call = function (cls, ...)
	   local self = setmetatable({}, cls)
	   self:_init(...)
	   return self
	end,
})

function ActionState:_init()
	-- noop
end

function ActionState.processControls(self, key)
	error("Default processControls implementation")
end

-- should only print these in debug mode
function ActionState.draw(self)
	error("Default draw implementation")
end

function ActionState.update(self, dt)
	error("Default update implementation")
end

function ActionState.keypressed(self, key)
	error("Default keypressed implementation")
end

function ActionState.keyreleased(self, key)
	error("Default keyreleased implementation")
end

function ActionState.mousepressed(self, x, y, button)
	error("Default mousepressed implementation")
end

function ActionState.gamepadpressed(self, joystick, button)
	error("Default gamepadpressed implementation")
end

function ActionState.joystickaxis(self, joystick, axis, value)
	error("Default joystickaxis implementation")
end