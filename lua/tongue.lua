require("lua/utils")

Tongue = {}
Tongue.__index = Tongue

setmetatable(Tongue, {
	__index = Tongue,
	__call = function (cls, ...)
	   local self = setmetatable({}, cls)
	   self:_init(...)
	   return self
	end,
})

function Tongue:_init()
	-- State handling
	self.states = {
		["tongue"] = "tongue",
		["grabbed"] = "grabbed",
		["retracting"] = "retracting",
		["spawning"] = "spawning"
	}
	self.state = self.states.tongue

	-- Physics
	self.dampeningFactor = 0.96

	-- Tongue size and segments
	self.tongueSegments = 10
	self.segments = {}

	-- Base location
	self.baseDegree = 0

	-- Color controls
	self.hue = 0
	self.hueVelocity = 1

	-- Grabbed item handler
	self.grabbedItem = {}
	self.grabbedItem.item = nil
	self.grabbedItem.timer = 0
end

function Tongue.new(self, gameWorld, tongueSegments, hueVelocity)
	self.gameWorld = gameWorld
	self.xOffset = gameWorld.width/2
	self.yOffset = gameWorld.height/2

	self.segmentBaseSize = gameWorld.width/96 --20 in a 1920px screen

	local world = gameWorld:getWorld()

	self.tongueSegments = tongueSegments
	self.hueVelocity = hueVelocity

	local xVector = math.sin(math.rad(self.baseDegree))
	local yVector = math.cos(math.rad(self.baseDegree))

	local xPos = (self.xOffset * xVector) + self.xOffset
	local yPos = (self.yOffset * yVector) + self.yOffset

	self.segments.base = {}
	self.segments.base.body = love.physics.newBody(world, xPos, yPos, "static")
	self.segments.base.shape = love.physics.newCircleShape(self.segmentBaseSize)
	self.segments.base.fixture = love.physics.newFixture(self.segments.base.body, self.segments.base.shape, 0)
	self.segments.base.fixture:setUserData({
		["type"] = "base"
	})

	local distance = self.segmentBaseSize * 1.5
	--yPos = yPos - 30
	local newXPos = xPos - (distance * xVector)
	local newYPos = yPos - (distance * yVector)
--print(xPos .. " " .. yPos)
--print("Big element" .. newXPos .. " " .. newYPos)
	self.segments.segment1 = {}
	self.segments.segment1.body = love.physics.newBody(world, newXPos, newYPos, "dynamic")
	self.segments.segment1.shape = love.physics.newCircleShape(self.segmentBaseSize/2)
	self.segments.segment1.fixture = love.physics.newFixture(self.segments.segment1.body, self.segments.segment1.shape, 0)
	self.segments.segment1.fixture:setUserData({
		["type"] = "segment"
	})
	self.segments.segment1.fixture:setSensor(true)
	local joint = love.physics.newDistanceJoint(self.segments.base.body, self.segments.segment1.body, xPos, yPos, newXPos, newYPos, self.segmentBaseSize)
	joint:setFrequency(7)

	local previousBody = self.segments.segment1.body
	--yPos = yPos - 20

	distance = self.segmentBaseSize
	xPos = newXPos
	yPos = newYPos

	newXPos = xPos - (distance * xVector)
	newYPos = yPos - (distance * yVector)
--print(xPos .. " " .. yPos)
--print(newXPos .. " " .. newYPos)
	for i=2,self.tongueSegments-1 do
		self.segments["segment"..i] = {}
		self.segments["segment"..i].body = love.physics.newBody(world, newXPos, newYPos, "dynamic")
		self.segments["segment"..i].shape = love.physics.newCircleShape((self.segmentBaseSize/2) + (i/4))
		self.segments["segment"..i].fixture = love.physics.newFixture(self.segments["segment"..i].body, self.segments["segment"..i].shape, 0)
		self.segments["segment"..i].fixture:setUserData({
			["type"] = "segment"
		})
		self.segments["segment"..i].fixture:setSensor(true)
		local joint = love.physics.newDistanceJoint(previousBody, self.segments["segment"..i].body, xPos, yPos, newXPos, newYPos, self.segmentBaseSize)
		--joint:setFrequency(5)

		previousBody = self.segments["segment"..i].body
		--yPos = yPos - 20
		distance = self.segmentBaseSize
		xPos = newXPos
		yPos = newYPos
		newXPos = xPos - (distance * xVector)
		newYPos = yPos - (distance * yVector)

		--print((self.segmentBaseSize/2) .. " " .. (i/self.segmentIncrement))
		--print(newXPos .. " " .. newYPos)
	end

	self.segments["segment"..self.tongueSegments] = {}
	self.segments["segment"..self.tongueSegments].body = love.physics.newBody(world, newXPos, newYPos, "dynamic")
	self.segments["segment"..self.tongueSegments].shape = love.physics.newCircleShape((self.segmentBaseSize/2) + (self.tongueSegments/4))
	self.segments["segment"..self.tongueSegments].fixture = love.physics.newFixture(self.segments["segment"..self.tongueSegments].body, self.segments["segment"..self.tongueSegments].shape, 0)
	self.segments["segment"..self.tongueSegments].fixture:setUserData({
		["type"] = "segment"
	})
	self.segments["segment"..self.tongueSegments].fixture:setSensor(true)
	love.physics.newDistanceJoint(previousBody, self.segments["segment"..self.tongueSegments].body, xPos, yPos, newXPos, newYPos, self.segmentBaseSize)

	--yPos = yPos - 30
	distance = self.segmentBaseSize * 1.5
	xPos = newXPos
	yPos = newYPos

	newXPos = xPos - (distance * xVector)
	newYPos = yPos - (distance * yVector)
--print(xPos .. " " .. yPos)
--print(newXPos .. " " .. newYPos)

	self.segments.bud = {}
	self.segments.bud.body = love.physics.newBody(world, newXPos, newYPos, "dynamic")
	self.segments.bud.shape = love.physics.newCircleShape(self.segmentBaseSize * 1.5)
	self.segments.bud.fixture = love.physics.newFixture(self.segments.bud.body, self.segments.bud.shape, 0)
	self.segments.bud.fixture:setUserData({
		["type"] = "bud"
	})
	love.physics.newDistanceJoint(self.segments["segment"..self.tongueSegments].body, self.segments.bud.body, xPos, yPos, newXPos, newYPos, self.segmentBaseSize * 1.5)
end

function Tongue.draw(self)
	love.graphics.setColor(HSL(self.hue%255,255,128))
	self.hue = self.hue + self.hueVelocity
	if self.hue > 255 then
		self.hue = 0
	end

	for k,v in pairs(self.segments) do
		love.graphics.circle("fill", v.body:getX(), v.body:getY(), v.shape:getRadius())
	end
end

-- Adjust this to the control scheme
function Tongue.processControls(self, input)
	if self.state == self.states.tongue then
		if love.keyboard.isDown("right") then --press the right arrow key to push the ball to the right
			self.segments.bud.body:applyForce(5000, 0)
		elseif love.keyboard.isDown("left") then --press the left arrow key to push the ball to the left
			self.segments.bud.body:applyForce(-5000, 0)
		end

		if love.keyboard.isDown("up") then --press the up arrow key to set the ball in the air
			self.segments.bud.body:applyForce(0, -5000)
		elseif love.keyboard.isDown("down") then --press the up arrow key to set the ball in the air
			self.segments.bud.body:applyForce(0, 5000)
		end

		if love.keyboard.isDown("d") then --press the right arrow key to push the ball to the right
			self.baseDegree = self.baseDegree + 0.25

			local xPos = self.xOffset * math.sin(math.rad(self.baseDegree))
			local yPos = self.yOffset * math.cos(math.rad(self.baseDegree))
			self.segments.base.body:setX(xPos + self.xOffset)
			self.segments.base.body:setY(yPos + self.yOffset)
		elseif love.keyboard.isDown("a") then --press the left arrow key to push the ball to the left
			--self.segments.base.body:applyForce(-5000, 0)
			self.baseDegree = self.baseDegree - 0.25

			local xPos = self.xOffset * math.sin(math.rad(self.baseDegree))
			local yPos = self.yOffset * math.cos(math.rad(self.baseDegree))
			self.segments.base.body:setX(xPos + self.xOffset)
			self.segments.base.body:setY(yPos + self.yOffset)
		end

		-- focus meter or something
		if love.keyboard.isDown("space") then
			for k,v in pairs(self.segments) do
				local x, y = v.body:getLinearVelocity()
				v.body:setLinearVelocity(x*self.dampeningFactor, y*self.dampeningFactor)
			end
		end
	end
end

function Tongue.update(self, dt)
	-- initiate retraction!
	if (
		(self.state == self.states.tongue)
		and (not (self.grabbedItem.item == nil))
	) then
		self.state = self.states.grabbed
		local item = self.grabbedItem.item
		love.physics.newDistanceJoint(self.segments.bud.body, item:getBody(), self.segments.bud.body:getX(), self.segments.bud.body:getY(), item:getBody():getX(), item:getBody():getY(), 5)
		self.grabbedItem.timer = 0
		for k,v in pairs(self.segments) do
			v.body:setLinearVelocity(0, 0)
		end
	elseif (self.state == self.states.grabbed) then
		self.grabbedItem.timer = self.grabbedItem.timer + dt
		if self.grabbedItem.timer > 0.25 then
			self.state = self.states.retracting
		end
	elseif (self.state == self.states.retracting) then
		self.segments.base.body:setType("dynamic")
		local i = 0
		for k,v in pairs(self.segments) do
			local xPos = math.sin(math.rad(self.baseDegree))
			local yPos = math.cos(math.rad(self.baseDegree))
			local multiplier = 1000 - 5*i
			if multiplier <= 0 then
				multiplier = 1
			end
			v.body:applyForce(multiplier*xPos, multiplier*yPos)
			i = i + 1
		end
		self.grabbedItem.item:getBody():setType("dynamic")
	elseif (self.state == self.states.spawning) then
		Tongue.new(self, self.gameWorld, 30, 5) -- rename or something. Tongue needs a spawning state to mean something. Segments should spawn in one at a time from the base
		self.state = self.states.tongue
	end
end

function Tongue.beginContact(self, a, b, coll)	
	if (
		(self.state == self.states.tongue)
		and (a:getUserData().type == "bud")
		and (b:getUserData().type == "item")
	) then
		if self.grabbedItem.item == nil then
			self.grabbedItem.item = b
			b:getUserData().grabbedCallback()
		end
	elseif (
		(self.state == self.states.retracting)
		and (a:getUserData().type == "edge")
		and (b:getUserData().type == "bud")
	) then
		-- item despawn logic
		self.grabbedItem.item:getUserData().collectedCallback()
		self.grabbedItem.item:getBody():destroy()
		self.grabbedItem.item = nil
		self.grabbedItem.timer = 0
		self:destroy()

		self.state = self.states.spawning
	end
end

function Tongue.destroy(self)
	for k,v in pairs(self.segments) do
		v.body:destroy()
	end
	self.segments = {}
	-- I'm assuming GC will handle the rest...
end