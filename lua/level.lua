require("lua/factories/itemFactory")
require("lua/scene")

Level = {}
Level.__index = Level

setmetatable(Level, {
	__index = Level,
	__call = function (cls, ...)
	   local self = setmetatable({}, cls)
	   self:_init(...)
	   return self
	end,
})

--[[
	Adjust constructor paramters to take in info
]]
function Level:_init(gameWorld)
	self.states = {
		["ready"] = "ready",
		["active"] = "active",
		["transitioning"] = "transitioning",
		["complete"] = "complete"
	}
	self.state = self.states.ready

	self.itemFactory = ItemFactory(gameWorld)

	self.name = "level1"
	self.scenes = {}

	self.scenes[1] = Scene(self.itemFactory, self.name, -1920, -1080, {
		[1] = {
			["image"] = "mug1",
			["x"] = 1920 / 2 + 200,
			["y"] = 1080 / 2 + 200
		}
	})
	self.scenes[2] = Scene(self.itemFactory, self.name, 0, 0, {
		[1] = {
			["image"] = "mouse1",
			["x"] = 1920 / 2 - 200,
			["y"] = 1080 / 2 - 200
		}
	})

	self.currentScene = 1
	self.scenes[self.currentScene]:registerItems()
end

function Level.draw(self)
	self.scenes[self.currentScene]:draw()
end
