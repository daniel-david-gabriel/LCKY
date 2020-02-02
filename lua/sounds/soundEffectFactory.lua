SoundEffectFactory = {}
SoundEffectFactory.__index = SoundEffectFactory

setmetatable(SoundEffectFactory, {
	__index = SoundEffectFactory,
	__call = function (cls, ...)
	   local self = setmetatable({}, cls)
	   self:_init(...)
	   return self
	end,
})

function SoundEffectFactory:_init()
	self.soundEffectBaseDirectory = "media/effects/"
	self.soundEffects = {}

	local effects = love.filesystem.getDirectoryItems(self.soundEffectBaseDirectory)
	for i,effect in pairs(effects) do
		local effectNameTokens = split(effect, "[^%.]+")
		self.soundEffects[effectNameTokens[1]] = love.audio.newSource(self.soundEffectBaseDirectory .. effect, "static")
		self.soundEffects[effectNameTokens[1]]:setLooping(false)
	end
end

function SoundEffectFactory.getSoundEffects(self)
	return self.soundEffects
end
