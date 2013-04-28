
ZombieSpawn = class("ZombieSpawn", Entity)

function ZombieSpawn:initialize()
	
	Entity.initialize(self)
	
	self._enabled = false
	self._next = engine.currentTime() + 5 + math.random()*10
end

function ZombieSpawn:update( dt )
	
	if (self._next < engine.currentTime()) then
		self._next = engine.currentTime() + 5 + math.random()*10
		
		local pos = self:getPos()
		if (self._enabled and not level:getCamera():isRectInView( pos.x, pos.y, 32, 32 )
			and #level:getEntitiesByClass(Zombie) < 30) then
			local ent = level:createEntity("Zombie", level:getPhysicsWorld())
			ent:setPos(pos)
		end
		
	end
	
end

function ZombieSpawn:enable()

	self._enabled = true

end