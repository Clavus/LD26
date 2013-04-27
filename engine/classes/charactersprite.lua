
CharacterSprite = class("CharacterSprite")

--[[
void CharacterSprite:setState( state )
void CharacterSprite:setSpeed( speed )
void CharacterSprite:resetAnimation()
void CharacterSprite:update( dt )
void CharacterSprite:draw(x, y, r, sx, sy)

Layout format example:

layout = {
	[0] = {
		state_name = "moveleft",
		num_columns = 4,
		num_frames = 8,
		offset = Vector(0,0), -- relative offset. So on the image it's image_offset + this offset
		fps = 2, -- frames per second
		loops = false,
	}
	[1] = {
		etc...
	}
}
]]--

function CharacterSprite:initialize( layout, image_file, img_offset, frame_size, frame_origin )
	
	self._sprites = {}
	self._state = ""
	self._speed = 1
	
	for k, v in pairs( layout ) do
		local sData = SpriteData( image_file, img_offset + v.offset, frame_size, frame_origin, v.num_columns, v.num_frames, v.fps, v.loops )
		self._sprites[v.state_name] = Sprite(sData)
	end
	
end

function CharacterSprite:setState( state, reapply )
	
	if (self._sprites[state] and not (not reapply and state == self._state)) then
		self._sprites[state]:reset()
		self._sprites[state]:setSpeed( self._speed )
		self._state = state		
	end
	
end

function CharacterSprite:setSpeed( speed )

	self._speed = speed
	if (self._sprites[self._state]) then
		self._sprites[self._state]:setSpeed( speed )
	end
	
end

function CharacterSprite:resetAnimation()
	
	if (self._sprites[self._state]) then
		self._sprites[self._state]:reset()
	end
	
end

function CharacterSprite:update( dt )
	
	if (self._sprites[self._state]) then
		self._sprites[self._state]:update( dt )
	end
	
end

function CharacterSprite:draw(x, y, r, sx, sy)
	
	if (self._sprites[self._state]) then
		self._sprites[self._state]:draw( x, y, r, sx, sy )
	end
	
end