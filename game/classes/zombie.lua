
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
	
	if (player:getPos():distance(self:getPos()) < 360 and false) then
		self._fsm:triggerEvent("see player")
		changed = true
	elseif (self.time_nextaction < engine.currentTime()) then
		self._fsm:triggerEvent("time passed")
		self.time_nextaction = engine.currentTime() + 2 + math.random() * 3
		changed = true
	end
	
	if (changed) then
		self.velocity.x = 0
		self.velocity.y = 0
		if (self._fsm:getState() == "idle") then
		
			self._charsprite:resetAnimation()
			
		elseif (self._fsm:getState() == "walk") then
			local choice = math.choose("moveleft", "moveright", "movedown", "moveup")
			self._animstate = choice
			self._charsprite:setState(choice)
	
			if (choice == "moveleft") then
				self.velocity.x = -16
				self.velocity.y = 0
			elseif (choice == "moveright") then
				self.velocity.x = 16
				self.velocity.y = 0
			elseif (choice == "movedown") then
				self.velocity.x = 0
				self.velocity.y = 16
			elseif (choice == "moveup") then
				self.velocity.x = 0
				self.velocity.y = -16
			end
		end
	end
	
end

function Zombie:setPos( vec )

	self._body:setPosition(vec.x, vec.y)

end

function Zombie:getPos()

	return Vector(self._body:getPosition())
	
end
