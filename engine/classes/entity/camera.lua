
Camera = class("Camera", Entity)

function Camera:initialize()
	
	Entity.initialize(self)
	
	self._angle = 0
	self._scale = Vector(1,1)
	self._pos = Vector(0,0)
	
	self._refpos = Vector(0,0)
	self._targetpos = Vector(0,0)
	self._easingfunc = easing.inOutQuint
	self._easingstart = -100
	self._easingduration = 2
	
end

function Camera:update(dt)
	
	local t = engine.currentTime() - self._easingstart
	if (t <= self._easingduration) then
		self._pos.x = self._easingfunc(t, self._refpos.x, self._targetpos.x - self._refpos.x, self._easingduration)
		self._pos.y = self._easingfunc(t, self._refpos.y, self._targetpos.y - self._refpos.y, self._easingduration)
	else
		self._pos = self._targetpos
	end
	
	--self._pos.x = self._pos.x + 50*dt
	--self._scale.x = 1 + 0.5*math.sin(engine.currentTime())
	--self._scale.y = 1 + 0.5*math.sin(engine.currentTime())
	
end

function Camera:getTargetPos()
	
	return self._targetpos:copy()
	
end

function Camera:setPos( pos )
	
	Entity.setPos(self, pos)
	self._refpos = pos
	self._targetpos = pos
	self._easingstart = -100
	
	level:updateActiveTiles()
	
end

function Camera:moveTo( pos, duration )
	
	self._targetpos = pos
	self._refpos = self._pos:copy()
	self._easingstart = engine.currentTime()
	self._easingduration = duration
	
	level:updateActiveTiles()
	
end

function Camera:preDraw()
	
	love.graphics.push()
	love.graphics.scale( self._scale.x, self._scale.y )
	love.graphics.rotate( self._angle )
	love.graphics.translate( math.round(-self._pos.x), math.round(-self._pos.y) )
	
end

function Camera:postDraw()
	
	love.graphics.pop()
	
end

function Camera:getWidth()
	
	return love.graphics.getWidth() / self._scale.x
	
end

function Camera:getHeight()
	
	return love.graphics.getHeight() / self._scale.y
	
end

function Camera:isRectInView( x, y, w, h )
	
	w = w or 0
	h = h or 0
	
	return (x >= self._pos.x - w and x <= self._pos.x + self:getWidth() and
			y >= self._pos.y - h and y <= self._pos.y + self:getHeight())
	
end

function Camera:setScale( sv )

	assert(sv.class and sv.class.name == "Vector", "Vector expected, got "..type(sv))
	self._scale = sv

end

function Camera:getScale()

	return self_scale

end

function Camera:setAngle( r )

	assert(type(r) == "number", "Number expected, got "..type(r))
	self._angle = r
	
end

function Camera:getAngle( r )

	return self._angle

end
