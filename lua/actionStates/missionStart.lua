require("lua/overlay")

MissionStart = {}
MissionStart.__index = MissionStart

setmetatable(MissionStart, {
	__index = ActionState,
	__call = function (cls, ...)
	   local self = setmetatable({}, cls)
	   self:_init(...)
	   return self
	end,
})

function MissionStart:_init()
	ActionState._init(self)

	self.states = {
		["text"] = "text",
		["fadeIn"] = "fadeIn",
		["done"] = "done"
	}

	self.state = self.states.text

	self.timer = 0
	self.alpha = 0

	self.overlay = Overlay("backwards", 3)

	-- Color controls
	self.hue = 0
	self.hueVelocity = -3
end

function MissionStart.draw(self)
	
	self.hue = self.hue + self.hueVelocity
	if self.hue > 255 then
		self.hue = 0
	end

	if self.state == self.states.text then
		--love.graphics.setColor(1, 1, 1, 1)
		love.graphics.setColor(HSL(self.hue%255,255,128))
		love.graphics.printf("MISSION START", 0, love.graphics.getHeight()/2 - 20, love.graphics.getWidth(), "center")
	elseif self.state == self.states.fadeIn or self.state == self.states.done then
		game.level:draw()
		self.overlay:draw()

		love.graphics.setColor(0, 0, 0, 1-(self.alpha/255))
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

		--love.graphics.setColor(1, 1, 1, 1)
		love.graphics.setColor(HSL(self.hue%255,255,128))
		love.graphics.printf("MISSION START", 0, love.graphics.getHeight()/2 - 20, love.graphics.getWidth(), "center")
	end
end

function MissionStart.update(self, dt)
	if self.state == self.states.text then
		self.timer = self.timer + dt
		if self.timer >= 0.5 then
			self.state = self.states.fadeIn
		end
	elseif self.state == self.states.fadeIn then
		if self.alpha < 64 then
			self.alpha = self.alpha + 1
		elseif self.alpha < 128 then
			self.alpha = self.alpha + 2
		else
			self.alpha = self.alpha + 4
		end

		if self.alpha >= 255 then
			self.state = self.states.done
		end
	else
		toState = game
	end
end

--[[
	Disable controls during mission start display
]]
function MissionStart.processControls(self, key)
	-- noop
end

function MissionStart.keyreleased(key)
	-- noop
end

function MissionStart.mousepressed(x, y, button)
	-- noop
end
