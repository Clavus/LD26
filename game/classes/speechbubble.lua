
SpeechBubble = class("SpeechBubble", Entity)

function SpeechBubble:initialize( stype, duration )
	
	Entity.initialize( self )
	
	self._spr = StateAnimatedSprite( SPRITELAYOUT["speechbubble"], FOLDER.ASSETS.."bubbles128.png", Vector(0,0), Vector(128,128), Vector(128,128) )
	self._spr:setState( stype )
	
	self._relative_depth = -100
	
	self._duration = duration or -1
	self._start = engine.currentTime()
	
	self._hscale = 0
	self._animdur = 2
	self._animstart = engine.currentTime()
	
	self._attached = nil
	
	self._elstart = 0
	self._eltarget = 1
	
end

function SpeechBubble:update( dt )
	
	if (self._attached) then
		self:setPos( self._attached:getPos() + Vector(0,-32) )
	end
	
	if (self._duration ~= -1) then
		if (self._start + self._duration < engine.currentTime()) then
			level:removeEntity(self)
		end
	end
	
	local t = engine.currentTime() - self._animstart
	self._hscale = easing.outElastic(t, self._elstart, self._eltarget, self._animdur, 0.4, self._animdur/3)
	
end

function SpeechBubble:draw()
	
	local pos = self:getPos()
	pos:snap(Vector(1,1))
	
	self._spr:draw(pos.x, pos.y, 0, 1, self._hscale)
	
end

function SpeechBubble:getDrawLayer()
	
	return DRAW_LAYER_TOP
	
end

function SpeechBubble:attachTo( other )
	
	self._attached = other
	
end