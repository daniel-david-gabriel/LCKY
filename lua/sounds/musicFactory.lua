MusicFactory = {}
MusicFactory.__index = MusicFactory

setmetatable(MusicFactory, {
	__index = MusicFactory,
	__call = function (cls, ...)
	   local self = setmetatable({}, cls)
	   self:_init(...)
	   return self
	end,
})

function MusicFactory:_init()
	self.musicBaseDirectory = "media/music/"
	self.music = {}

	local songs = love.filesystem.getDirectoryItems(self.musicBaseDirectory)
	for i,song in pairs(songs) do
		local songNameTokens = split(song, "[^%.]+")
		self.music[songNameTokens[1]] = love.audio.newSource(self.musicBaseDirectory .. song, "stream")
		self.music[songNameTokens[1]]:setLooping(true)
	end
end

function MusicFactory.getMusic(self)
	return self.music
end