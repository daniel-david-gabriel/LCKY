CursorMenu = {}
CursorMenu.__index = CursorMenu

setmetatable(CursorMenu, {
  __index = ActionState,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function CursorMenu:_init(options)
	ActionState._init(self)

	self.options = options

	self.selection = 1
	self.submenuCount = table.getn(self.options) or 1

	self.sfx = "menu"
end

function CursorMenu.draw(self)
	for i,menuEntry in pairs(self.options) do
		local offset = 32 * i
		love.graphics.printf(menuEntry["text"], love.graphics.getWidth()/4, love.graphics.getHeight()/2 + offset, love.graphics.getWidth()/2, "center")
	end
	

	-- TODO fix xOffset here
	love.graphics.rectangle("fill", love.graphics.getWidth()/2 - 50, love.graphics.getHeight()/2 + 32*self.selection, 10, 10)
end

function CursorMenu.processControls(self, input)
	if controls:isUp(input) then
		if self.selection > 1 then
			self.selection = self.selection - 1
			soundEffects:playSoundEffect(self.sfx)
		end
	elseif controls:isDown(input) then
		if self.selection < self.submenuCount then
			self.selection = self.selection + 1
			soundEffects:playSoundEffect(self.sfx)
		end
	elseif controls:isMenu(input) or controls:isConfirm(input) then
		local selection = self.options[self.selection]
		if selection then
			local callback = selection["callback"]
			if callback then
				callback()
			else
				if debug then
					error("Selection does not have a callback")
				end
			end
		else
			if debug then
				error("Tried to load invalid selection " .. self.selection)
			end
		end
	else
		--
	end
end

function CursorMenu.keyreleased(key)
	-- noop
end

function CursorMenu.mousepressed(x, y, button)
	-- noop
end
