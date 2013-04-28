
SpeechBubble = class("SpeechBubble", Entity)

function SpeechBubble:initialize( stype )
	
	Entity.initialize( self )
	
	self._spr = StateAnimatedSprite( SPRITELAYOUT["speechbubble"], FOLDER.ASSETS.."bubbles128.png", Vector(0,0), Vector(128,128), Vector(128,128) )
	self._spr:setState( stype )
	
	self._relative_depth = -100
	
	self._hscale = 0
	self._dur = 2
	self._start = engine.currentTime()
	
end

function SpeechBubble:update( dt )
	
	local t = engine.currentTime() - self._start
	self._hscale = easing.outElastic(t, 0, 1, self._dur, 0.4, self._dur/3)
	
end

function SpeechBubble:draw()
	
	local pos = self:getPos()
	self._spr:draw(pos.x, pos.y, 0, 1, self._hscale)
	
end