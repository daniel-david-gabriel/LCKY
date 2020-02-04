require("lua/actionStates/game")
require("lua/actionStates/mainMenu")
require("lua/actionStates/missionStart")
require("lua/actionStates/options")
require("lua/factories/imageFactory")
require("lua/sounds/music")
require("lua/sounds/soundEffects")

LoadingScreen = {}
LoadingScreen.__index = LoadingScreen

setmetatable(LoadingScreen, {
  __index = ActionState,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function LoadingScreen:_init()
	ActionState._init(self)

	-- Specify a preloading state to make sure that draw is called before we
	-- attempt to load the first category of assets.
	self.preloading = true
	self.loading = true
	self.loadingText = ""

	self.background = love.graphics.newImage("assets/darkBackground.png") -- Make a new one of these
end

function LoadingScreen.draw(self)
	love.graphics.setColor(255, 255, 255, 0.5)
	love.graphics.draw(self.background, 0, 0)

	
	love.graphics.printf(self.loadingText, 0, love.graphics.getHeight()/2 - 20, love.graphics.getWidth(), "center")
end

function LoadingScreen.update(self, dt)
	if self.preloading then
		self.preloading = false
		self.loadingText = "Loading Images..."
	elseif not imageFactory then
		imageFactory = ImageFactory()
		self.loadingText = "Loading Music..."
	elseif not music then
		music = Music()
		self.loadingText = "Loading Sound Effects..."
	elseif not soundEffects then
		soundEffects = SoundEffects()
		self.loadingText = "Loading World..."
	elseif not game then
		game = Game()
		self.loadingText = "Loading Game States..."
	elseif not missionStart then
		missionStart = MissionStart()
		mainMenu = MainMenu()
		options = Options()
		options.videoOptions:refreshDisplay()
		self.loadingText = "Done!"
		self.loading = false
	end
	-- Load music, SFX, etc here.

	if not self.loading then
		if imageFactory and music and game and mainMenu and missionStart then
			toState = mainMenu
		end
	end
end
