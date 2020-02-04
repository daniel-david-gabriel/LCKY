require("lua/actionStates/cursorMenu")
require("lua/actionStates/videoOptions")
require("lua/actionStates/soundOptions")

Options = {}
Options.__index = Options


setmetatable(Options, {
  __index = CursorMenu,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Options:_init()
	self.debug = true -- pull from file?
	self.videoOptions = VideoOptions()
	self.soundOptions = SoundOptions()
	
	local optionsMenuOptions = {}
	optionsMenuOptions[1] = {
		["text"] = function() return "Video" end,
		["callback"] = function() toState = self.videoOptions end,
	}
	optionsMenuOptions[2] = {
		["text"] = function() return "Sound" end,
		["callback"] = function() toState = self.soundOptions end,
	}
	optionsMenuOptions[3] = {
		["text"] = function() return "Controls" end,
		["callback"] = function() print("Controls option not created yet") end,
	}
	optionsMenuOptions[4] = {
		["text"] = function() return "Debug: " .. tostring(self.debug) end,
		["callback"] = function() self.debug = not self.debug end,
	}
	optionsMenuOptions[5] = {
		["text"] = function() return "Back" end,
		["callback"] = function() toState = mainMenu end,
	}

	CursorMenu._init(self, "darkBackground", optionsMenuOptions)
end

function Options.draw(self)
	CursorMenu.draw(self)
end

function Options.keyreleased(self, key)
	--
end

function Options.mousepressed(self, x, y, button)
	--
end

function Options.update(self, dt)

end

