
resource = {}

local loaded_images = {}

function resource.getImage( image_file )
	
	if (image_file == nil) then return end
	
	if (loaded_images[image_file] == nil) then
		loaded_images[image_file] = love.graphics.newImage(image_file)
	end
	
	return loaded_images[image_file]
	
end

function resource.getImageDimensions( image_file )
	
	local img = resource.getImage( image_file )
	return Vector(img:getWidth(), img:getHeight())
	
end
