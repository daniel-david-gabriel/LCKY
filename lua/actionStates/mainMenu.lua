require("lua/actionStates/cursorMenu")

MainMenu = {}
MainMenu.__index = MainMenu

setmetatable(MainMenu, {
  __index = CursorMenu,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function MainMenu:_init()
	local mainMenuOptions = {}
	mainMenuOptions[1] = {
		["text"] = function() return "New Game" end,
		["callback"] = function() toState = missionStart end,
	}
	mainMenuOptions[2] = {
		["text"] = function() return "Load Game" end,
		["callback"] = function() game:load(Save("save.dat")) toState = game end,
	}
	mainMenuOptions[3] = {
		["text"] = function() return "Options" end,
		["callback"] = function() toState = options end,
	}
	mainMenuOptions[4] = {
		["text"] = function() return "Credits" end,
		["callback"] = function() toState = credits end,
	}
	mainMenuOptions[5] = {
		["text"] = function() return "Quit" end,
		["callback"] = function() love.event.push("quit") end,
	}

	CursorMenu._init(self, "darkBackground", mainMenuOptions)

	self.title = love.graphics.newImage("assets/title.png")
        self.cloud = love.graphics.newImage("assets/cloud.png")
	self.sfx = "menu"

	--self.credits = Credits()

	self.numberOfClouds = 0
	self.maxClouds = 100
	self.cloudAlpha = 0
	self.cloudPositions = {}
	self.cloudTimer = 0

	--prepopulate clouds
	for i=1,100 do
		if self.numberOfClouds < self.maxClouds then
			self.cloudPositions[love.math.random(600) - 40] = love.math.random(800)
			self.numberOfClouds = self.numberOfClouds + 1
        end
	end
end

function MainMenu.draw(self)
	CursorMenu.draw(self)

	for k,v in pairs(self.cloudPositions) do
		love.graphics.setColor(255, 255, 255, self.cloudAlpha)
		love.graphics.draw(self.cloud, v, k)
                self.cloudPositions[k] = v - 1
                if self.cloudPositions[k] <= -100 then
			table.remove(self.cloudPositions, k)
			self.numberOfClouds = self.numberOfClouds - 1
                end
	end

	love.graphics.setColor(255, 255, 255, 255)
	--love.graphics.printf(self.menuText, love.graphics.getWidth()/4, love.graphics.getHeight()/2, love.graphics.getWidth()/2, "center")

	love.graphics.draw(self.title, 0, 0)	
end

function MainMenu.update(self, dt)
	music:playMusic("LiquidSnow")

	if self.cloudTimer <= 0 then
		if self.numberOfClouds < self.maxClouds then
			self.cloudPositions[love.math.random(600) - 40] = 800
			self.numberOfClouds = self.numberOfClouds + 1
                        self.cloudTimer = love.math.random(100)
        	end
	else
		self.cloudTimer = self.cloudTimer - (dt * 1000)
	end

	if self.cloudAlpha < 16 then
		self.cloudAlpha = self.cloudAlpha + 1
	end
end
