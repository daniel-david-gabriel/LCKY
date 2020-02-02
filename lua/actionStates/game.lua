require("lua/actionState")
require("lua/gameWorld")
require("lua/level")
require("lua/overlay")
require("lua/tongue")

Game = {}
Game.__index = Game

setmetatable(Game, {
  __index = ActionState,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Game:_init()
	ActionState._init(self)

	self.gameWorld = GameWorld()
	self.gameWorld:new(beginContact, endContact, preSolve, postSolve)

	self.tongue = Tongue()
	self.tongue:new(self.gameWorld, 30, 5)

	self.overlay = Overlay("forwards", 1)

	self.level = Level(self.gameWorld)
end

function Game.draw(self)
	self.level:draw()

	self.tongue:draw()
	self.overlay:draw()

	-- HUD Draw

	local debug = true
	if debug then
		self.gameWorld:draw()

		-- Print bounding ring for edge movement
		for i=0,720 do
			local x = (self.gameWorld.width/2) * math.sin(math.rad(i/2))
			local y = (self.gameWorld.height/2) * math.cos(math.rad(i/2))
			love.graphics.rectangle( "fill", (self.gameWorld.width/2) + x, (self.gameWorld.height/2) + y, 2, 2)
		end
	end
end

function Game.update(self, dt)
	music:playMusic("SpeedReed")
	self.gameWorld:update(dt)
	self.tongue:processControls(nil)
	self.tongue:update(dt)
end

function Game.beginContact(self, a, b, coll)
	self.tongue:beginContact(a, b, coll)
end

function Game.processControls(self, key)
	self.tongue:processControls(key)
end

function Game.keyreleased(key)
	-- noop
end

function Game.mousepressed(x, y, button)
	-- noop
end
