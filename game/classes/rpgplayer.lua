
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
	
	self.hp = 100
	self.mana = 100
	self.exp = 0
	self.lvl = 0
	
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
	
end

function RPGPlayer:draw()
	
	local pos = self:getPos()
	pos:snap(Vector(1,1))
	self._charsprite:draw(pos.x, pos.y)
	
	if (self.is_attacking) then
		self._attackeffect:draw(pos.x + self._attackeffect_offset.x, pos.y + self._attackeffect_offset.y)
	end
	
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
	self.velocity.x = 0
	self.velocity.y = 0
		
end

function RPGPlayer:handleMovement()
	
	-- fancy control scheme shenanigans
	
	local left, right, down, up = input:keyIsDown(INPUT.MOVELEFT),input:keyIsDown(INPUT.MOVERIGHT), input:keyIsDown(INPUT.MOVEDOWN), input:keyIsDown(INPUT.MOVEUP)
	local pleft, pright, pdown, pup = input:keyIsPressed(INPUT.MOVELEFT),input:keyIsPressed(INPUT.MOVERIGHT), input:keyIsPressed(INPUT.MOVEDOWN), input:keyIsPressed(INPUT.MOVEUP)
	
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
		
	else
		
		if (self._animstate == "attackleft") then self._animstate = "moveleft"
		elseif (self._animstate == "attackright") then self._animstate = "moveright"
		elseif (self._animstate == "attackdown") then self._animstate = "movedown"
		elseif (self._animstate == "attackup") then self._animstate = "moveup"
		end
		
		self._charsprite:setState(self._animstate, true)
	
		-- standing still
		self._charsprite:setSpeed(0)
		self.velocity.x = 0
		self.velocity.y = 0
		
	end
	
end
