require("lua/sounds/musicFactory")

Music = {}
Music.__index = Music

setmetatable(Music, {
  __index = Music,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Music:_init()
	local musicFactory = MusicFactory()
	self.music = musicFactory:getMusic()

	self.currentSong = ""
end

function Music.playMusic(self, songName)
	local song = self.music[songName]
	if song then
		if self.currentSong == song then
			return
		end

		if self.currentSong ~= "" then
			self.currentSong:stop()
		end

		song:setVolume(options.soundOptions.masterVolume * options.soundOptions.bgmVolume)
		song:play()
		self.currentSong = song
	else
		if debug then
			error("Tried to play nil muisic file " .. songName)
		end
	end
end

function Music.stopAllSounds(self)
	if self.currentSong ~= "" then
		self.currentSong:stop()
	end
end

function Music.applyVolume(self)
	self.currentSong:setVolume(options.soundOptions.masterVolume * options.soundOptions.bgmVolume)
end

