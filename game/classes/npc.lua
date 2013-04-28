
NPC = class("NPC", Entity)

function NPC:initialize( world, scenario )
	
	Entity.initialize(self)
	
	self._charsprite = StateAnimatedSprite( SPRITELAYOUT["npc"], FOLDER.ASSETS.."char_sheet64.png", Vector(CHARACTER_FRAME_SIZE*12,0), Vector(64,64), Vector(32,32) )
	
	self.scenario = scenario
	
	self.velocity = Vector(0,0)
	
	self._animstate = "sad"
	self._charsprite:setState(self._animstate)
	self._charsprite:setSpeed(1)
	
	self._animtoggle_next = engine.currentTime() + 2
	
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
		
		print("toggle "..self._animtoggle_next)
		local sp = self._charsprite:getSpeed()
		print("speed = "..self._charsprite:getSpeed())
		self._charsprite:resetAnimation()
		self._charsprite:setSpeed(sp * -1 )
		print("speed = "..self._charsprite:getSpeed())
		self._animtoggle_next = engine.currentTime() + 2
	end


end

function NPC:draw()
	
	local pos = self:getPos()
	pos:snap(Vector(1,1))
	self._charsprite:draw(pos.x, pos.y)
	
end