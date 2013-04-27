
RPGPlayer = class("RPGPlayer", Player)

function RPGPlayer:initialize( world )

	Player.initialize(self, world)
	
	self._charsprite = CharacterSprite( SPRITELAYOUT["character"], FOLDER.ASSETS.."char_sheet64.png", Vector(0,0), Vector(64,64), Vector(32,32) )
	
	self.velocity = Vector(0,0)
	self.move_speed = 196
	
	self._animstate = "movedown"
	self._charsprite:setState(self._animstate)
	
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
	
	-- fancy control scheme shenanigans
	
	local left, right, down, up = input:keyIsDown(INPUT.MOVELEFT),input:keyIsDown(INPUT.MOVERIGHT), input:keyIsDown(INPUT.MOVEDOWN), input:keyIsDown(INPUT.MOVEUP)
	local pleft, pright, pdown, pup = input:keyIsPressed(INPUT.MOVELEFT),input:keyIsPressed(INPUT.MOVERIGHT), input:keyIsPressed(INPUT.MOVEDOWN), input:keyIsPressed(INPUT.MOVEUP)
	
	if (pleft or (left and not pright and not pdown and not pup)) then
	
		self._charsprite:setState("moveleft", false)
		self._charsprite:setSpeed(1)
		self.velocity.x = -self.move_speed
		self.velocity.y = 0
		
	elseif (pright or (right and not pdown and not pup)) then
	
		self._charsprite:setState("moveright", false)
		self._charsprite:setSpeed(1)
		self.velocity.x = self.move_speed
		self.velocity.y = 0
		
	elseif (pdown or (down and not pup)) then
	
		self._charsprite:setState("movedown", false)
		self._charsprite:setSpeed(1)
		self.velocity.x = 0
		self.velocity.y = self.move_speed
		
	elseif (pup or up) then
	
		self._charsprite:setState("moveup", false)
		self._charsprite:setSpeed(1)
		self.velocity.x = 0
		self.velocity.y = -self.move_speed
		
	else
		
		-- standing still
		self._charsprite:setSpeed(0)
		self._charsprite:resetAnimation()
		self.velocity.x = 0
		self.velocity.y = 0
		
	end
	
	if (self.velocity:length() > 0) then
		self:setPos( self:getPos() + (self.velocity * dt) )
	end
	
end

function RPGPlayer:draw()
	
	local pos = self:getPos()
	pos:snap(Vector(1,1))
	self._charsprite:draw(pos.x, pos.y)
	
end