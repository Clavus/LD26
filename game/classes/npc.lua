
NPC = class("NPC", Entity)

function NPC:initialize( world, scenario )
	
	Entity.initialize(self)
	
	self._charsprite = StateAnimatedSprite( SPRITELAYOUT["npc"], FOLDER.ASSETS.."char_sheet64.png", Vector(CHARACTER_FRAME_SIZE*12,0), Vector(64,64), Vector(32,32) )
	
	self.scenario = scenario
	self.bubbletext = "obstacle"
	
	self.velocity = Vector(0,0)
	
	self._animstate = "sad"
	self._charsprite:setState(self._animstate)
	self._charsprite:setSpeed(1)
	
	self._animtoggle_next = engine.currentTime() + 3
	self._showbubble = true
	
	self._body = love.physics.newBody(world, 0, 0, "dynamic")
	self._body:setMass(1)
	self._shape = love.physics.newCircleShape(0, 16, 16)
	self._fixture = love.physics.newFixture(self._body, self._shape)
	self._fixture:setUserData(self)
	
end

function NPC:update( dt )
	
	self._charsprite:update(dt)
	
	if ((self._animstate == "sad" or self._animstate == "happy") and
		self._animtoggle_next < engine.currentTime()) then
		
		self._charsprite:resetAnimation()
		self._animtoggle_next = engine.currentTime() + 3
	end
	
	local pldis = (player:getPos() - self:getPos()):length()
	
	if (pldis < 100 and self._showbubble) then
		
		if (self.scenario == "obstacle") then
			local bubble = level:createEntity("SpeechBubble", self.bubbletext, 3)
			bubble:attachTo(self)
		end
		
		self._showbubble = false
		
	elseif (pldis > 200) then
		self._showbubble = true
	end

end

function NPC:draw()
	
	local pos = self:getPos()
	pos:snap(Vector(1,1))
	self._charsprite:draw(pos.x, pos.y)
	
end

function NPC:triggerHappyness( scenario )
	
	if (scenario ~= self.scenario) then return end
	
	self._animstate = "happy"
	self._charsprite:setState(self._animstate)
	self._animtoggle_next = engine.currentTime() + 3
	
	self.bubbletext = "hero"
	self._showbubble = true
	
end

function NPC:setPos( vec )

	self._body:setPosition(vec.x, vec.y)

end

function NPC:getPos()

	return Vector(self._body:getPosition())
	
end
