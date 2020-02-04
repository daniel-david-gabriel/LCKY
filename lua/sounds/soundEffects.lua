require("lua/sounds/soundEffectFactory")

SoundEffects = {}
SoundEffects.__index = SoundEffects

setmetatable(SoundEffects, {
  __index = SoundEffects,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function SoundEffects:_init()
	local soundEffectFactory = SoundEffectFactory()
	self.soundEffects = soundEffectFactory:getSoundEffects()
end

function SoundEffects.playSoundEffect(self, effectName)
	local soundEffect = self.soundEffects[effectName]
	if soundEffect then
		if soundEffect:isPlaying() then
			soundEffect:stop()
		end
		soundEffect:setVolume(options.soundOptions.masterVolume * options.soundOptions.sfxVolume)
		soundEffect:play()
	else
		if debug then
			error("Tried to play nil sound effect " .. effectName)
		end
	end
end
