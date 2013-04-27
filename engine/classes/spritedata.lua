
SpriteData = class("SpriteData")

function SpriteData:initialize( imageFile, offset, imgsize, origin, numcolums, numframes, frames_per_sec, should_loop )

	self._file = imageFile
	self.image = resource.getImage(imageFile)
	self.offset = offset or Vector(0,0)
	self.size = imgsize or Vector(32,32)
	self.origin_pos = origin or Vector(0,0)
	self.num_columns = numcolums or 1
	self.num_frames = numframes or 1
	self.fps = frames_per_sec or 0
	self.should_loop = should_loop or false
	
end