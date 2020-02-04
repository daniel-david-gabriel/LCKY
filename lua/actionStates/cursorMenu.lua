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

function CursorMenu:_init(background, options)
	ActionState._init(self)

	self.backgroundImage = imageFactory:getMenuImage(background)

	self.options = options

	self.selection = 1
	self.submenuCount = table.getn(self.options) or 1

	self.sfx = "menu"
end

function CursorMenu.draw(self)
	--determine scaling for background image
	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()
	local imageWidth = self.backgroundImage:getWidth()
	local imageHeight = self.backgroundImage:getHeight()

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.backgroundImage, 0, 0, 0, width / imageWidth, height / imageHeight)


	for i,menuEntry in pairs(self.options) do
		if menuEntry["text"] then
			local offset = 32 * i
			love.graphics.printf(menuEntry["text"](), love.graphics.getWidth()/4, love.graphics.getHeight()/2 + offset, love.graphics.getWidth()/2, "center")
		else
			if options.debug then
				error("Showing a menu item without text")
			end
		end
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
	elseif controls:isLeft(input) then
		local selection = self.options[self.selection]
		if selection then
			local leftCallback = selection["leftCallback"]
			if leftCallback then
				leftCallback()
			end
		else
			if options.debug then
				error("Tried to load invalid selection " .. self.selection)
			end
		end
	elseif controls:isRight(input) then
		local selection = self.options[self.selection]
		if selection then
			local rightCallback = selection["rightCallback"]
			if rightCallback then
				rightCallback()
			end
		else
			if options.debug then
				error("Tried to load invalid selection " .. self.selection)
			end
		end
	elseif controls:isMenu(input) or controls:isConfirm(input) then
		local selection = self.options[self.selection]
		if selection then
			local callback = selection["callback"]
			if callback then
				callback()
			end
		else
			if options.debug then
				error("Tried to load invalid selection " .. self.selection)
			end
		end
	else
		-- noop
	end
end

function CursorMenu.keyreleased(key)
	-- noop
end

function CursorMenu.mousepressed(x, y, button)
	-- noop
end
