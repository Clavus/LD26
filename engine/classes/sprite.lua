
Sprite = class("Sprite")

function Sprite:initialize( sData )
	
	self._image = sData.image
	self._size = sData.size or Vector(32,32)
	self._origin_pos = sData.origin_pos or Vector(0,0)
	self._num_frames = sData.num_frames or 1
	self._fps = sData.fps or 0
	self._loops = sData.should_loop or false
	self._cur_frame = 1
	self._ended = false
	
	self.visible = true
	
	local quads = {}
	local col = 0
	local row = 0
	local fw, fh = self._size.x, self._size.y
	local img = self_image
	
	for i = 1, self._num_frames do
		table.insert(quads, love.graphics.newQuad(col*fw, row*fh, fw, fh, img:getWidth(), img:getHeight()))
		col = col + 1
		if (col >= sData.cols) then
			col = 0
			row = row + 1
		end
	end
	
	self._frames = quads
	
end

function Sprite:update( dt )

	if (self._num_frames > 1 and self._fps ~= 0 and not self._ended) then
		self._cur_frame = self._cur_frame + (dt * self._fps)
		
		if (self._cur_frame >= self._num_frames+1) then
			if (self._loops) then
				self._cur_frame = 1
			else
				self._cur_frame = self._num_frames
				self._ended = true
			end
		end
	end

end

function Sprite:draw(x, y, r, sx, sy)
	
	if not self.visible then return end
	
	r = r or 0
	sx = sx or 1
	sy = sy or 1	
	local frame = self._frames[math.floor(self._cur_frame)]
	local origin = self._origin_pos
	love.graphics.drawq(self._image, frame, x, y, r, sx, sy, origin.x, origin.y)

end


function Sprite:getCurrentFrame()
	
	return math.floor(self._cur_frame)
	
end

