
Zombie = class("Zombie", Entity)

function Zombie:initialize( world )
	
	Entity.initialize(self)
	
	self._charsprite = StateAnimatedSprite( SPRITELAYOUT["zombie"], FOLDER.ASSETS.."char_sheet64.png", Vector(0,CHARACTER_FRAME_SIZE*4), Vector(64,64), Vector(32,32) )
	self._fsm = FiniteStateMachine( FSM["zombie"], "idle" )
	
	self.velocity = Vector(0,0)
	self.move_speed = 196/2
	self.last_attack = -100
	
	self.time_nextaction = engine.currentTime() + 2 + math.random() * 3
	self.hp = 100
	
	self._animstate = "movedown"
	self._charsprite:setState(self._animstate)
	
	self._body = love.physics.newBody(world, 0, 0, "dynamic")
	self._body:setMass(1)
	self._shape = love.physics.newCircleShape(16)
	self._fixture = love.physics.newFixture(self._body, self._shape)
	self._fixture:setUserData(self)
	
end

function Zombie:update(dt)
	
	self._charsprite:update(dt)
	self:thinkHardAboutLife()
	
	if (self.velocity:length() > 0) then
		self._charsprite:setSpeed(1)
		self:setPos( self:getPos() + (self.velocity * dt) )
	else
		self._charsprite:setSpeed(0)
	end
	
end

function Zombie:draw()
	
	local pos = self:getPos()
	pos:snap(Vector(1,1))
	self._charsprite:draw(pos.x, pos.y)
	
end

function Zombie:thinkHardAboutLife()
	
	local changed = false
	local pldis = player:getPos():distance(self:getPos())
	local prev_state = self._fsm:getState()
	
	if (pldis < 360 and not player:isDead()) then
		self._fsm:triggerEvent("see player")
	elseif (pldis > 500 or player:isDead()) then
		self._fsm:triggerEvent("lost player")
	end
	
	if (self.time_nextaction < engine.currentTime()) then
		if (self._fsm:triggerEvent("time passed")) then
			self.time_nextaction = engine.currentTime() + 2 + math.random() * 3
		end
	end
	
	--print(self:getEntIndex()..": "..self._fsm:getState())
	
	-- things that needs to be triggered once
	if (prev_state ~= self._fsm:getState()) then
	
		if (self._fsm:getState() == "idle") then
			
			self.velocity.x = 0
			self.velocity.y = 0
			self._charsprite:resetAnimation()
			
		elseif (self._fsm:getState() == "walk") then
		
			self._animstate = math.choose("moveleft", "moveright", "movedown", "moveup")
			self._charsprite:setState(self._animstate)
	
			if (self._animstate == "moveleft") then
				self.velocity.x = -32
				self.velocity.y = 0
			elseif (self._animstate == "moveright") then
				self.velocity.x = 32
				self.velocity.y = 0
			elseif (self._animstate == "movedown") then
				self.velocity.x = 0
				self.velocity.y = 32
			elseif (self._animstate == "moveup") then
				self.velocity.x = 0
				self.velocity.y = -32
			end
			
		end
		
	end
	
	-- continious triggers
	if (self._fsm:getState() == "attack") then
			
		self.velocity = (player:getPos() - self:getPos()):normalize() * 32
		
		if (math.abs(self.velocity.x) < math.abs(self.velocity.y)) then
			if (self.velocity.y < 0) then self._animstate = "moveup"
			else self._animstate = "movedown" end
		else
			if (self.velocity.x < 0) then self._animstate = "moveleft"
			else self._animstate = "moveright" end
		end
		
		self._charsprite:setState(self._animstate)
		
	end
		
end

function Zombie:attackPlayer( pl )
	
	if (self._fsm:getState() ~= "attack" or self.last_attack > engine.currentTime() - 1) then return end
	
	self.last_attack = engine.currentTime()
	pl:takeDamage( self )
	
end

function Zombie:setPos( vec )

	self._body:setPosition(vec.x, vec.y)

end

function Zombie:getPos()

	return Vector(self._body:getPosition())
	
end
