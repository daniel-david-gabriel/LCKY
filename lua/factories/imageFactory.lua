ImageFactory = {}
ImageFactory.__index = ImageFactory

setmetatable(ImageFactory, {
	__index = ImageFactory,
	__call = function (cls, ...)
	   local self = setmetatable({}, cls)
	   self:_init(...)
	   return self
	end,
})

function ImageFactory:_init()
	self.overlayImageBaseDirectory = "media/overlay/"
	self.overlayImages = {}

	local overlays = love.filesystem.getDirectoryItems(self.overlayImageBaseDirectory)
	for i,overlay in pairs(overlays) do
		self.overlayImages[i] = love.graphics.newImage(self.overlayImageBaseDirectory .. overlay)
	end

	self.levelImageBaseDirectory = "media/background/"
	self.levelImages = {}

	local levels = love.filesystem.getDirectoryItems(self.levelImageBaseDirectory)
	for i,level in pairs(levels) do
		local levelNameTokens = split(level, "[^%.]+")
		self.levelImages[levelNameTokens[1]] = love.graphics.newImage(self.levelImageBaseDirectory .. level)
	end

	self.itemImageBaseDirectory = "media/items/"
	self.itemImages = {}

	local items = love.filesystem.getDirectoryItems(self.itemImageBaseDirectory)
	for i,item in pairs(items) do
		local itemNameTokens = split(item, "[^%.]+")
		self.itemImages[itemNameTokens[1]] = love.graphics.newImage(self.itemImageBaseDirectory .. item)
	end
end

function ImageFactory.getOverlayImages(self)
	return self.overlayImages
end

function ImageFactory.getLevelImage(self, name)
	return self.levelImages[name]
end

function ImageFactory.getItemImage(self, name)
	return self.itemImages[name]
end
