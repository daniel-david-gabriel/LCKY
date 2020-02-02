Item = {}
Item.__index = Item

setmetatable(Item, {
	__index = Item,
	__call = function (cls, ...)
	   local self = setmetatable({}, cls)
	   self:_init(...)
	   return self
	end,
})

function Item:_init(gameWorld, image, x, y, radius, xOffset, yOffset, grabbedCallback, collectedCallback)
	self.image = image

	self.radius = radius
	self.xOffset = xOffset
	self.yOffset = yOffset

	self.body = love.physics.newBody(gameWorld:getWorld(), x, y, "static")
	self.shape = love.physics.newCircleShape(radius)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
	self.fixture:setSensor(true)
	self.fixture:setUserData({
		["type"] = "item",
		["grabbedCallback"] = grabbedCallback,
		["collectedCallback"] = collectedCallback
	})
end

function Item.draw(self)
	if not self.body:isDestroyed() then
		local width = self.image:getWidth()
		local height = self.image:getHeight()

		local xScale = 2 * (self.radius / width)
		local yScale = 2 * (self.radius / height)

		local x, y = self.body:getPosition()
		love.graphics.circle("fill", x, y, self.radius)
		local debug = true
		if debug then
			love.graphics.draw(self.image, x, y, 0, xScale, yScale, self.xOffset, self.yOffset)
		end
	end
end