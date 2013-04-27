
SpriteData = class("SpriteData")

function SpriteData:initialize( imageFile )

	self._file = imageFile
	self._image = love.graphics.newImage(imageFile)
	
end