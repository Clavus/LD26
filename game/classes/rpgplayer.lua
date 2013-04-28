
RPGPlayer = class("RPGPlayer", Player)

local attack_duration = 1/6 -- third of a second

function RPGPlayer:initialize( world )

	Player.initialize(self, world)
	
	self._charsprite = StateAnimatedSprite( SPRITELAYOUT["character"], FOLDER.ASSETS.."char_sheet64.png", Vector(0,0), Vector(64,64), Vector(32,32) )
	self._attackeffect = StateAnimatedSprite( SPRITELAYOUT["effect_attack"], FOLDER.ASSETS.."effects64.png", Vector(0,0), Vector(64,64), Vector(32,32) )
	self.velocity = Vector(0,0)
	self.move_speed = 196
	self.last_attack = -100
	self.is_attacking = false
	
	self._animstate = "movedown"
	self._charsprite:setState(self._animstate)
	self._attackeffect_offset = Vector(0,0)
	
	self._damaged = false
	self._dead = false
	
	self.hp = 100
	self.mana = 100
	self.exp = 0
	self.lvl = 0
	
	self.sound_attack = resource.getSound(FOLDER.ASSETS.."sound/sword1.ogg","static")
	self.sound_hurt = resource.getSound(FOLDER.ASSETS.."sound/hurt1.ogg","static")
	
	-- gui elements for character
	local guisize = resource.getImageDimensions(FOLDER.ASSETS.."gui_front.png")
	local pl = self
	
	gui:addSimpleElement(10, Vector(16, 16), FOLDER.ASSETS.."gui_front.png")
	gui:addDynamicElement(20, Vector(16, 16), function(pos) love.graphics.rectangle("fill", pos.x, pos.y, guisize.x, guisize.y) end)
	gui:addDynamicElement(15, Vector(16, 16), function(pos) 
		love.graphics.setColor( 255, 0, 0, 255 )
		love.graphics.rectangle("fill", pos.x + 4, pos.y + 4, math.ceil(86*pl.hp/100), 14)
		love.graphics.setColor( 0, 255, 255, 255 )
		love.graphics.rectangle("fill", pos.x + 4, pos.y + 22, math.ceil(86*pl.mana/100), 14)
		love.graphics.setColor( 0, 255, 216, 255 )
		love.graphics.rectangle("fill", pos.x + 4, pos.y + 40, math.ceil(86*pl.exp/100), 14)
		love.graphics.setColor( 255, 255, 255, 255 )
	end)
	
end

function RPGPlayer:update( dt )
	
	self._charsprite:update(dt)
	
	if (not self:isDead()) then
	
		if (self.last_attack > engine.currentTime() - attack_duration) then
			-- attacking
			self._attackeffect:update(dt)
		elseif (input:keyIsPressed(INPUT.ATTACK)) then
			self:attack()
		else
			self.is_attacking = false
			self:handleMovement()
		end
		
		if (self.velocity:length() > 0) then
			self:setPos( self:getPos() + (self.velocity * dt) )
		end
		
	else
		self:setPos(self._deathPos)
	end
	
end

function RPGPlayer:draw()
	
	local pos = self:getPos()
	pos:snap(Vector(1,1))
	
	if (self._damaged and math.floor((engine.currentTime() * 10) % 2) == 1) then
		love.graphics.setColor(200,100,100,255)
	end
	
	self._charsprite:draw(pos.x, pos.y)
	
	love.graphics.setColor(255,255,255,255)
	
	if (self.is_attacking) then
		self._attackeffect:draw(pos.x + self._attackeffect_offset.x, pos.y + self._attackeffect_offset.y)
	end
	
end

function RPGPlayer:takeDamage( from )

	if (instanceOf(Zombie, from)) then
		
		self.hp = math.max(0, self.hp - 25)
		if (self.hp == 0) then
			self:die()
		end
		
		self.sound_hurt:play()
		
		self._damaged = true
		timer.simple(0.7, function(self) self._damaged = false end, self)
		
	end


end

function RPGPlayer:die()
	
	self._dead = true
	self._deathPos = self:getPos()
	
	self._animstate = "death"
	self._charsprite:setState("death", false)
	self._charsprite:setSpeed(1)
	
	timer.simple(1, function(self)
		local ent = level:createEntity("SpeechBubble", "restart")
		ent:setPos(self:getPos() + Vector(-8,-32))
	end, self)
	
	self._attackeffect:resetAnimation()
	
end

function RPGPlayer:isDead()
	
	return self._dead
	
end

function RPGPlayer:attack()
	
	if (self._animstate == "moveleft") then 
		self._animstate = "attackleft"
		self._attackeffect:setState("left")
		self._attackeffect_offset = Vector(-32,0)
	elseif (self._animstate == "moveright") then 
		self._animstate = "attackright"
		self._attackeffect:setState("right")
		self._attackeffect_offset = Vector(32,0)
	elseif (self._animstate == "movedown") then 
		self._animstate = "attackdown"
		self._attackeffect:setState("down")
		self._attackeffect_offset = Vector(0, 32)
	elseif (self._animstate == "moveup") then 
		self._animstate = "attackup"
		self._attackeffect:setState("up")
		self._attackeffect_offset = Vector(0, -32)
	end
	
	self.last_attack = engine.currentTime()
	self.is_attacking = true
	
	self._attackeffect:resetAnimation()
	self._attackeffect:setSpeed(1)
	
	self._charsprite:setState(self._animstate, true)
	self._charsprite:setSpeed(1)
	
	self.sound_attack:play()
	
	local world = level:getPhysicsWorld()
	local pos = self:getPos()
	local attackvec = self:getPos() + (self._attackeffect_offset * 1.5)
	world:rayCast( pos.x, pos.y, attackvec.x, attackvec.y, function(f, x, y, xn, yn, frac)
		local hit = f:getUserData()
		if (instanceOf(Zombie, hit)) then hit:takeDamage(self, 50) return 0
		else return 1 end
	end)
	
	self.velocity.x = 0
	self.velocity.y = 0
		
end

function RPGPlayer:handleMovement()
	
	-- fancy control scheme shenanigans
	
	local left, right, down, up = input:keyIsDown(INPUT.MOVELEFT),input:keyIsDown(INPUT.MOVERIGHT), input:keyIsDown(INPUT.MOVEDOWN), input:keyIsDown(INPUT.MOVEUP)
	local pleft, pright, pdown, pup = input:keyIsPressed(INPUT.MOVELEFT),input:keyIsPressed(INPUT.MOVERIGHT), input:keyIsPressed(INPUT.MOVEDOWN), input:keyIsPressed(INPUT.MOVEUP)
	local no_move = true
	
	if (left) then
		
		if (not up and not down) then
			self._animstate = "moveleft"
			self._charsprite:setState("moveleft", false)
			self._charsprite:setSpeed(1)
		end
		
		self.velocity.x = -self.move_speed
		no_move = false
		
	elseif (right) then
		
		if (not up and not down) then
			self._animstate = "moveright"
			self._charsprite:setState("moveright", false)
			self._charsprite:setSpeed(1)
		end
		
		self.velocity.x = self.move_speed
		no_move = false
		
	else
		self.velocity.x = 0
	end
	
	if (up) then
	
		self._animstate = "moveup"
		self._charsprite:setState("moveup", false)
		self._charsprite:setSpeed(1)
		self.velocity.y = -self.move_speed
		no_move = false
		
	elseif (down) then
		
		self._animstate = "movedown"
		self._charsprite:setState("movedown", false)
		self._charsprite:setSpeed(1)
		self.velocity.y = self.move_speed
		no_move = false
		
	else
		self.velocity.y = 0
	end
	
	if (self.velocity:length() > 0) then
		self.velocity = self.velocity:getNormal() * self.move_speed
	end
	
	--[[
	if (pleft or (left and not pright and not pdown and not pup)) then
		
		self._animstate = "moveleft"
		self._charsprite:setState("moveleft", false)
		self._charsprite:setSpeed(1)
		self.velocity.x = -self.move_speed
		self.velocity.y = 0
		
	elseif (pright or (right and not pdown and not pup)) then
		
		self._animstate = "moveright"
		self._charsprite:setState("moveright", false)
		self._charsprite:setSpeed(1)
		self.velocity.x = self.move_speed
		self.velocity.y = 0
		
	elseif (pdown or (down and not pup)) then
		
		self._animstate = "movedown"
		self._charsprite:setState("movedown", false)
		self._charsprite:setSpeed(1)
		self.velocity.x = 0
		self.velocity.y = self.move_speed
		
	elseif (pup or up) then
		
		self._animstate = "moveup"
		self._charsprite:setState("moveup", false)
		self._charsprite:setSpeed(1)
		self.velocity.x = 0
		self.velocity.y = -self.move_speed
	]]--
	
	
	if (no_move) then
		
		if (self._animstate == "attackleft") then self._animstate = "moveleft"
		elseif (self._animstate == "attackright") then self._animstate = "moveright"
		elseif (self._animstate == "attackdown") then self._animstate = "movedown"
		elseif (self._animstate == "attackup") then self._animstate = "moveup"
		end
		
		self._charsprite:setState(self._animstate, true)
	
		-- standing still
		self._charsprite:setSpeed(0)
		
	end
	
end
