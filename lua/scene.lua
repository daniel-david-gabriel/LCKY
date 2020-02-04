Scene = {}
Scene.__index = Scene

setmetatable(Scene, {
	__index = Scene,
	__call = function (cls, ...)
	   local self = setmetatable({}, cls)
	   self:_init(...)
	   return self
	end,
})

--[[
	
]]
function Scene:_init(itemFactory, backgroundImage, x, y, items)
	self.backgroundImage = backgroundImage
	self.x = x
	self.y = y

	self.items = {}
	for i,item in pairs(items) do
		self.items[i] = itemFactory:getItem(item.image, item.x, item.y)
	end
end

function Scene.draw(self)
	love.graphics.draw(imageFactory:getLevelImage(self.backgroundImage), self.x, self.y)

	for i,item in pairs(self.items) do
		item:draw()
	end
end

function Scene.registerItems(self)
	for i,item in pairs(self.items) do
		item:register()
	end
end
