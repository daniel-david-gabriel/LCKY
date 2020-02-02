Overlay = {}
Overlay.__index = Overlay

setmetatable(Overlay, {
	__index = Overlay,
	__call = function (cls, ...)
	   local self = setmetatable({}, cls)
	   self:_init(...)
	   return self
	end,
})

function Overlay:_init(direction, speed)
	self.directions = {
		["forwards"] = -1,
		["backwards"] = 1
	}

	self.direction = tonumber(self.directions[direction])
	self.speed = speed

	self.overlays = imageFactory:getOverlayImages()
	self.numberOfFrames = table.getn(self.overlays)
	self.counter = self.numberOfFrames
end

function Overlay.draw(self)
	love.graphics.setColor(255, 255, 255, 255)

	love.graphics.draw(self.overlays[self.counter])
	self.counter = self.counter + (self.direction * self.speed)
	if self.counter <= 0 then
		self.counter = self.numberOfFrames
	elseif self.counter > self.numberOfFrames then
		self.counter = 1
	end
end
