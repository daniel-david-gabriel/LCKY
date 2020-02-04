require("lua/actionStates/cursorMenu")

VideoOptions = {}
VideoOptions.__index = VideoOptions


setmetatable(VideoOptions, {
  __index = CursorMenu,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function VideoOptions:_init()
	local videoOptionsMenuOptions = {}
	videoOptionsMenuOptions[1] = {
		["text"] = function() return "Window Size: " .. self.windowSizes[self.windowSizeIndex] end,
		["leftCallback"] = function() if self.windowSizeIndex > 1 then self.windowSizeIndex  = self.windowSizeIndex - 1 end VideoOptions.refreshDisplay(self) end,
		["rightCallback"] = function() if self.windowSizeIndex < table.getn(self.windowSizes) then self.windowSizeIndex = self.windowSizeIndex + 1 end VideoOptions.refreshDisplay(self) end,
	}
	videoOptionsMenuOptions[2] = {
		["text"] = function() return "Fullscreen: " .. tostring(self.fullscreen) end,
		["callback"] = function() self.fullscreen = not self.fullscreen VideoOptions.refreshDisplay(self) end,
	}
	videoOptionsMenuOptions[3] = {
		["text"] = function() return "VSync: " .. tostring(self.vsync) end,
		["callback"] = function() self.vsync = not self.vsync VideoOptions.refreshDisplay(self) end,
	}
	videoOptionsMenuOptions[4] = {
		["text"] = function() return "Back" end,
		["callback"] = function() VideoOptions.saveOptions(self) toState = options end,
	}

	CursorMenu._init(self, "darkBackground", videoOptionsMenuOptions)

	self.videoOptionsFilename = "videoOptions.dat"

	self.windowSizes = {"640x480", "800x600", "1024x768", "1152x720", "1152x864",
			"1280x800", "1280x960", "1280x1024", "1446x900", "1680x1050", "1920x1080"
	}

	if love.filesystem.exists(self.videoOptionsFilename) then
		local videoOptions = love.filesystem.lines(self.videoOptionsFilename)
		for line in videoOptions do
			local lineTokens = split(line, "[^\t]+")
			self.windowSizeIndex = tonumber(lineTokens[1])
			if lineTokens[2] == "true" then
				self.fullscreen = true 
			else 
				self.fullscreen = false
			end
			if lineTokens[3] == "true" then
				self.vsync = true
			else
				self.vsync = false
			end
		end
	else
		self.windowSizeIndex = 2
		self.fullscreen = false
		self.vsync = true
	end

	self.tempWindowSizeIndex = self.windowSizeIndex
end


function VideoOptions.draw(self)
	CursorMenu.draw(self)
end

function VideoOptions.refreshDisplay(self)
	local lineTokens = split(self.windowSizes[self.windowSizeIndex], "[^x]+")
	local flags = {}
	flags.fullscreen = self.fullscreen
	flags.vsync = self.vsync
	love.window.setMode(tonumber(lineTokens[1]), tonumber(lineTokens[2]), flags)
end

function VideoOptions.saveOptions(self)
	local saveData = ""
	saveData = saveData .. self.windowSizeIndex .. "\t" .. tostring(self.fullscreen) .. "\t" .. tostring(self.vsync)
	love.filesystem.write(self.videoOptionsFilename, saveData)
end

function VideoOptions.keyreleased(self, key)
	--
end

function VideoOptions.mousepressed(self, x, y, button)
	--
end

function VideoOptions.update(self, dt)

end

