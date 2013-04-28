
Zombie = class("Zombie", Entity)
Zombie:include(CollisionResolver)

function Zombie:initialize( world )
	
	Entity.initialize(self)
	
	self._charsprite = StateAnimatedSprite( SPRITELAYOUT["zombie"], FOLDER.ASSETS.."char_sheet64.png", Vector(0,CHARACTER_FRAME_SIZE*4), Vector(64,64), Vector(32,32) )
	self._fsm = FiniteStateMachine( FSM["zombie"], "idle" )
	
	self.velocity = Vector(0,0)
	self.move_speed = 196/2
	self.last_attack = -100
	
	self.time_nextaction = engine.currentTime() + 2 + math.random() * 3
	self.hp = 100
	
	self._damaged = false
	self._dead = false
	
	self.sound_hurt = resource.getSound(FOLDER.ASSETS.."sound/hit1.ogg","static")
	
	self._animstate = "movedown"
	self._charsprite:setState(self._animstate)
	
	self._body = love.physics.newBody(world, 0, 0, "dynamic")
	self._body:setMass(1)
	self._shape = love.physics.newCircleShape(0, 16, 16)
	self._fixture = love.physics.newFixture(self._body, self._shape)
	self._fixture:setUserData(self)
	
end

function Zombie:update(dt)
	
	self._charsprite:update(dt)
	
	if (self._dead) then
		self._charsprite:setSpeed(1)
		self:setPos(self._deathPos)
	else	
		if (self.velocity:length() > 0 and not self._damaged) then
			self._charsprite:setSpeed(1)
			self:setPos( self:getPos() + (self.velocity * dt) )
		else
			self._charsprite:setSpeed(0)
		end
	end
	
	self:thinkHardAboutLife()
	
end

function Zombie:draw()
	
	local pos = self:getPos()
	pos:snap(Vector(1,1))
	
	if (self._damaged and math.floor((engine.currentTime() * 10) % 2) == 1) then
		love.graphics.setColor(200,100,100,255)
	end
	
	self._charsprite:draw(pos.x, pos.y)
	
	love.graphics.setColor(255,255,255,255)
	
end

function Zombie:resolveCollisionWith( other )
	
	if (instanceOf(RPGPlayer, other)) then
		self:attackPlayer(other)
	end
	
end

function Zombie:takeDamage( from, amount )
	
	if (self:isDead()) then return end
	
	self.hp = math.max(0, self.hp - amount)
	if (self.hp == 0) then
		self:die()
	end
	
	self.sound_hurt:play()
	
	self._damaged = true
	timer.simple(0.4, function(self) self._damaged = false end, self)

end

function Zombie:die()
	
	self._fsm:triggerEvent("killed")
	
	self._dead = true
	self._deathPos = self:getPos()
	
	self._animstate = "death"
	self._charsprite:setState("death", false)
	self._charsprite:setSpeed(1)
	
end

function Zombie:isDead()
	
	return self._dead
	
end

function Zombie:thinkHardAboutLife()
	
	local changed = false
	local pldis = player:getPos():distance(self:getPos())
	local prev_state = self._fsm:getState()
	
	if (self:isDead() and pldis > 600) then
		level:removeEntity(self)
		return
	end
	
	if (pldis < 280 and not player:isDead()) then
		self._fsm:triggerEvent("see player")
	elseif (pldis > 450 or player:isDead()) then
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

function Zombie:onRemove()
	
	self._body:destroy()
	
end

