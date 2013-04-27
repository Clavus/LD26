
Level = class('Level')

function Level:initialize( leveldata )

	self._leveldata = leveldata
	self._camera = Camera()
	
	love.physics.setMeter(1)
    self._physworld = love.physics.newWorld(0, 0, false)
	self._physworld:setCallbacks(self._beginContact, self._endContact, self._preSolve, self._postSolve)
	
	local objects = nil
	if (leveldata) then
		objects = leveldata.objects
	end
	
	self._entManager = EntityManager()
	self._entManager:loadLevelObjects(self, objects)
	
end

function Level:update( dt )

	self._camera:update(dt)
	self._physworld:update(dt)
	self._entManager:update(dt)
	
end

function Level:draw()

	self._camera:preDraw()
	
	if (self._leveldata) then
	
		for k, layer in ipairs( self._leveldata:getLayers() ) do
			-- draw all entities before the world layer
			if (layer.name == "world") then
				self._entManager:draw()
			end
		
			for i, tile in ipairs(layer.tiles) do
				local tset = tile.tileset
				love.graphics.drawq( tset.image, tile.draw_quad, tile.x, tile.y )
			end		
		end
		
	end
	
	self._camera:postDraw()
	
end

function Level:getPhysicsWorld()

	return self._physworld
	
end

function Level:createEntity( class, ... )

	return self._entManager:createEntity( class, ...)
	
end

function Level:getEntitiesByClass( class )

	return self._entManager:getEntsByClass( class )
	
end

function Level:_beginContact(a,b,coll) end
function Level:_endContact(a,b,coll) end
function Level:_preSolve(a,b,coll) end
function Level:_postSolve(a,b,coll) end
