
Zombie = class("Zombie", Entity)

function Zombie:initialize( world )
	
	Entity.initialize(self)
	
	self._charsprite = StateAnimatedSprite( SPRITELAYOUT["zombie"], FOLDER.ASSETS.."char_sheet64.png", Vector(0,CHARACTER_FRAME_SIZE*4), Vector(64,64), Vector(32,32) )
	
	self._body = love.physics.newBody(world, 0, 0, "dynamic")
	self._body:setMass(1)
	self._shape = love.physics.newCircleShape(16)
	self._fixture = love.physics.newFixture(self._body, self._shape)
	self._fixture:setUserData(self)
	
end
