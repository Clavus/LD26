
Camera = class("camera", Entity)

function Camera:initialize()
	
	Entity.initialize(self)
	
	self._angle = 0
	self._scale = Vector(1,1)
	self._pos = Vector(0,0,0)

end

function Camera:update(dt)
	
	--self._pos.x = self._pos.x + 50*dt
	--self._scale.x = 1 + 0.5*math.sin(engine.currentTime())
	--self._scale.y = 1 + 0.5*math.sin(engine.currentTime())
	
end

function Camera:preDraw()
	
	love.graphics.push()
	love.graphics.scale( self._scale.x, self._scale.y )
	love.graphics.rotate( self._angle )
	love.graphics.translate( -self._pos.x, -self._pos.y )
	
end

function Camera:postDraw()
	
	love.graphics.pop()
	
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
