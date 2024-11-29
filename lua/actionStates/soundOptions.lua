require("lua/actionStates/cursorMenu")

SoundOptions = {}
SoundOptions.__index = SoundOptions


setmetatable(SoundOptions, {
  __index = CursorMenu,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function SoundOptions:_init()
	self.soundOptionsFilename = "soundOptions.dat"

	if love.filesystem.getInfo(self.soundOptionsFilename) then
		local soundOptions = love.filesystem.lines(self.soundOptionsFilename)
		for line in soundOptions do
			local lineTokens = split(line, "[^\t]+")
			self.masterVolume = tonumber(lineTokens[1])
			self.bgmVolume = tonumber(lineTokens[2])
			self.sfxVolume = tonumber(lineTokens[3])
		end
	else
		self.masterVolume = 1.0
		self.bgmVolume = 1.0
		self.sfxVolume = 1.0
	end

	local soundOptionsMenuOptions = {}
	soundOptionsMenuOptions[1] = {
		["text"] = function() return "Master: " .. tostring(self.masterVolume * 10) end,
		["callback"] = function() print("Change window size") end,
		["leftCallback"] = function() SoundOptions.leftCallback(self, "masterVolume") end,
		["rightCallback"] = function() SoundOptions.rightCallback(self, "masterVolume") end,
	}
	soundOptionsMenuOptions[2] = {
		["text"] = function() return "BGM: " .. tostring(self.bgmVolume * 10) end,
		["callback"] = function() print("Change fullscreen") end,
		["leftCallback"] = function() SoundOptions.leftCallback(self, "bgmVolume") end,
		["rightCallback"] = function() SoundOptions.rightCallback(self, "bgmVolume") end,
	}
	soundOptionsMenuOptions[3] = {
		["text"] = function() return "SFX: " .. tostring(self.sfxVolume * 10) end,
		["callback"] = function() print("Change vSync") end,
		["leftCallback"] = function() SoundOptions.leftCallback(self, "sfxVolume") end,
		["rightCallback"] = function() SoundOptions.rightCallback(self, "sfxVolume") end,
	}
	soundOptionsMenuOptions[4] = {
		["text"] = function() return "Back" end,
		["callback"] = function() SoundOptions.saveCallback(self) end,
	}

	CursorMenu._init(self, "darkBackground", soundOptionsMenuOptions)
end

function SoundOptions.draw(self)
	CursorMenu.draw(self)
end

function SoundOptions.leftCallback(self, stream)
	self[stream] = self[stream] - 0.1
	if self[stream] < 0.05 then --Use 0.05 instead of 0.0 because FLOATING POINT MATH
		self[stream] = 0
	end

	music:applyVolume()
	soundEffects:playSoundEffect(self.sfx)
end

function SoundOptions.rightCallback(self, stream)
	self[stream] = self[stream] + 0.1
	if self[stream] >= 1.0 then
		self[stream] = 1.0
	end

	music:applyVolume()
	soundEffects:playSoundEffect(self.sfx)
end

function SoundOptions.saveCallback(self)
	local saveData = ""
	saveData = saveData .. self.masterVolume .. "\t" .. self.bgmVolume .. "\t" .. self.sfxVolume
	love.filesystem.write(self.soundOptionsFilename, saveData)

	soundEffects:playSoundEffect(self.sfx)

	toState = options
end

function SoundOptions.keyreleased(self, key)
	--
end

function SoundOptions.mousepressed(self, x, y, button)
	--
end

function SoundOptions.update(self, dt)

end

