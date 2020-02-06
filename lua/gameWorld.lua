GameWorld = {}
GameWorld.__index = GameWorld

setmetatable(GameWorld, {
	__index = GameWorld,
	__call = function (cls, ...)
	   local self = setmetatable({}, cls)
	   self:_init(...)
	   return self
	end,
})

function GameWorld:_init()
	self.width, self.height = love.graphics.getDimensions()

	self.meterLength = self.width / 64
	self.xGravity = 0
	self.yGravity = 0

	love.physics.setMeter(self.meterLength)
	self.world = love.physics.newWorld(self.xGravity, self.yGravity, true)

	self.boundary = {}

	self:makeEdge("left", 0, 0, 0, self.height)
	self:makeEdge("right", self.width, 0, self.width, self.height)
	self:makeEdge("top", 0, 0, self.width, 0)
	self:makeEdge("bottom", 0, self.height, self.width, self.height)

	-- Maybe split edge by 10ths?
	self:makeEdge("upperLeft1", 0, self.height/4, 3*self.width/8, 0)
	self:makeEdge("upperLeft2", 0, 3*self.height/8, self.width/4, 0)
	self:makeEdge("upperRight1", 5*self.width/8, 0, self.width, self.height/4)
	self:makeEdge("upperRight2", 3*self.width/4, 0, self.width, 3*self.height/8)
	self:makeEdge("lowerLeft1", 0, 5*self.height/8, self.width/4, self.height)
	self:makeEdge("lowerLeft2", 0, 3*self.height/4, 3*self.width/8, self.height)
	self:makeEdge("lowerRight1", 5*self.width/8, self.height, self.width, 3*self.height/4)
	self:makeEdge("lowerRight2", 3*self.width/4, self.height, self.width, 5*self.height/8)
end

function GameWorld.makeEdge(self, name, x1, y1, x2, y2)
	self.boundary[name] = {}
	self.boundary[name].body = love.physics.newBody(self.world, 0, 0, "static")
	self.boundary[name].shape = love.physics.newEdgeShape(x1, y1, x2, y2)
	self.boundary[name].fixture = love.physics.newFixture(self.boundary[name].body, self.boundary[name].shape, 1)
	self.boundary[name].fixture:setUserData({
  		["type"] = "edge"
	})
end

function GameWorld.new(self, beginContact, endContact, preSolve, postSolve)
	self.world:setCallbacks(beginContact, endContact, preSolve, postSolve)
end

function GameWorld.update(self, dt)
	self.world:update(dt)
end

function GameWorld.getWorld(self)
	return self.world
end

--[[
	A debug function that draws all boundary edges.
]]
function GameWorld.draw(self)
	if options and options.debug then
		love.graphics.setColor(255, 255, 255, 255)

		for k,v in pairs(self.boundary) do
			local x1, y1, x2, y2 = v.shape:getPoints()
			love.graphics.line(x1, y1, x2, y2)
		end
	end
end
