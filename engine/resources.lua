
resource = {}

local loaded_images = {}

function resource.getImage( imageFile )
	
	if (imageFile == nil) then return end
	
	if (loaded_images[imageFile] == nil) then
		loaded_images[imageFile] = love.graphics.newImage(imageFile)
	end
	
	return loaded_images[imageFile]
	
end
