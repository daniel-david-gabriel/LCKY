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
		["text"] = "New Game",
		["callback"] = function() toState = missionStart end,
	}
	mainMenuOptions[2] = {
		["text"] = "Load Game",
		["callback"] = function() game:load(Save("save.dat")) toState = game end,
	}
	mainMenuOptions[3] = {
		["text"] = "Options",
		["callback"] = function() toState = options end,
	}
	mainMenuOptions[4] = {
		["text"] = "Credits",
		["callback"] = function() toState = credits end,
	}
	mainMenuOptions[5] = {
		["text"] = "Quit",
		["callback"] = function() love.event.push("quit") end,
	}

	CursorMenu._init(self, mainMenuOptions)

	self.background = love.graphics.newImage("assets/darkBackground.png")
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
	--determine scaling for background image
	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()
	local imageWidth = self.background:getWidth()
	local imageHeight = self.background:getHeight()

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.background, 0, 0, 0, width / imageWidth, height / imageHeight)
	
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


	CursorMenu.draw(self)
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
