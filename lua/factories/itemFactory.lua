require("lua/item")

ItemFactory = {}
ItemFactory.__index = ItemFactory

setmetatable(ItemFactory, {
	__index = ItemFactory,
	__call = function (cls, ...)
	   local self = setmetatable({}, cls)
	   self:_init(...)
	   return self
	end,
})

function ItemFactory:_init(gameWorld)
	self.gameWorld = gameWorld

	self.mappings = {
		["mug1"] = {
			["radius"] = 100,
			["xOffset"] = 400,
			["yOffset"] = 200,
			["grabbedCallback"] = function()
				print("mug1 grabbed")
			end,
			["collectedCallback"] = function()
				print("mug1 collected")
			end
		},
		["mouse1"] = {
			["radius"] = 50,
			["xOffset"] = 200,
			["yOffset"] = 100,
			["grabbedCallback"] = function()
				print("mouse1 grabbed")
			end,
			["collectedCallback"] = function()
				print("mouse1 collected")
			end
		}
	}
end

function ItemFactory.getItem(self, name, x, y)
	local mapping = self.mappings[name]
	return Item(
		self.gameWorld,
		imageFactory:getItemImage(name),
		x,
		y,
		mapping.radius,
		mapping.xOffset,
		mapping.yOffset,
		mapping.grabbedCallback,
		mapping.collectedCallback
	)
end