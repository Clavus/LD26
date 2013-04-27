
Zombie = class("Zombie", Entity)

function Zombie:initialize( world )
	
	Entity.initialize(self)
	
	self._charsprite = StateAnimatedSprite( SPRITELAYOUT["zombie"], FOLDER.ASSETS.."char_sheet64.png", Vector(0,CHARACTER_FRAME_SIZE*4), Vector(64,64), Vector(32,32) )
	self.velocity = Vector(0,0)
	self.move_speed = 196/2
	self.last_attack = -100
	
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
	
end

function Zombie:draw()
	
	local pos = self:getPos()
	pos:snap(Vector(1,1))
	self._charsprite:draw(pos.x, pos.y)
	
end

function Zombie:setPos( vec )

	self._body:setPosition(vec.x, vec.y)

end

function Zombie:getPos()

	return Vector(self._body:getPosition())
	
end
