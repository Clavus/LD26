
Obstacle = class("Obstacle", Entity)

function Obstacle:initialize( world )
	
	Entity.initialize(self)
	
	self._spr = Sprite(SpriteData( FOLDER.ASSETS.."obstacle32.png", Vector(0,0), Vector(64, 192), Vector(0,0), 1, 1, 0, false ))
	self.sound_destroy = resource.getSound(FOLDER.ASSETS.."sound/hit1.ogg","static")
	
	self._body = love.physics.newBody(world, 0, 0, "static")
	self._body:setMass(1)
	self._shape = love.physics.newRectangleShape( 32, 96, 64, 192, 0 )
	self._fixture = love.physics.newFixture(self._body, self._shape)
	self._fixture:setUserData(self)
	
	self._destroyed = false
	
end

function Obstacle:destroy()
	
	self._destroyed = true
	
end

function Obstacle:update( dt )
	
	if (self._destroyed) then
		for k, ent in pairs(level:getEntitiesByClass(NPC)) do
			ent:triggerHappyness( "obstacle" )
		end
		
		self.sound_destroy:play()
	
		level:removeEntity(self)
		self._body:destroy()
	end
	
end

function Obstacle:draw()
	
	local pos = self:getPos()
	self._spr:draw(pos.x, pos.y)
	
end

function Obstacle:setPos( vec )

	self._body:setPosition(vec.x, vec.y)

end

function Obstacle:getPos()

	return Vector(self._body:getPosition())
	
end