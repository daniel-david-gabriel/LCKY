require("lua/controls/keyBindings")
require("lua/controls/gamepadBindings")

Controls = {}
Controls.__index = Controls

setmetatable(Controls, {
  __index = Controls,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Controls:_init()
	self.keyBindings = KeyBindings()
	self.gamepadBindings = GamepadBindings()

	love.keyboard.setKeyRepeat(true)
end

function Controls.isQuit(self, input)
	if love.keyboard.isDown(input) then
		return input == self.keyBindings:getQuit()
	else
		return input == self.gamepadBindings:getQuit()
	end
end

function Controls.isUp(self, input)
	if love.keyboard.isDown(input) then
		return input == self.keyBindings:getUp()
	else
		return input == self.gamepadBindings:getUp()
	end
end

function Controls.isDown(self, input)
	if love.keyboard.isDown(input) then
		return input == self.keyBindings:getDown()
	else
		return input == self.gamepadBindings:getDown()
	end
end

function Controls.isLeft(self, input)
	if love.keyboard.isDown(input) then
		return input == self.keyBindings:getLeft()
	else
		return input == self.gamepadBindings:getLeft()
	end
end

function Controls.isRight(self, input)
	if love.keyboard.isDown(input) then
		return input == self.keyBindings:getRight()
	else
		return input == self.gamepadBindings:getRight()
	end
end

function Controls.isMenu(self, input)
	if love.keyboard.isDown(input) then
		return input == self.keyBindings:getMenu()
	else
		return input == self.gamepadBindings:getMenu()
	end
end

function Controls.isBack(self, input)
	if love.keyboard.isDown(input) then
		return input == self.keyBindings:getBack()
	else
		return input == self.gamepadBindings:getBack()
	end
end

function Controls.isConfirm(self, input)
	if love.keyboard.isDown(input) then
		return input == self.keyBindings:getConfirm()
	else
		return input == self.gamepadBindings:getConfirm()
	end
end
