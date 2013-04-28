
Level = class('Level')

function Level:initialize( leveldata )

	self._leveldata = leveldata
	self._camera = Camera()
	
	love.physics.setMeter(1)
    self._physworld = love.physics.newWorld(0, 0, false)
	
	local objects = nil
	if (leveldata) then
		objects = leveldata.objects
	end
	
	self._entManager = EntityManager()
	self._entManager:loadLevelObjects(self, objects)
	
	self._layerindices = {}
	self._activetiles = {}
	
	self:updateActiveTiles()
	
end

function Level:update( dt )

	self._camera:update(dt)
	self._physworld:update(dt)
	self._entManager:update(dt)
	
end

function Level:updateActiveTiles()
	
	self._activetiles = {}
	self._entitydrawindex = nil
	
	if (self._leveldata) then
		
		local camx = self._camera:getTargetPos().x
		local camy = self._camera:getTargetPos().y
		local camw = self._camera:getWidth()
		local camh = self._camera:getHeight()
		local index = 1
		
		for k, layer in ipairs( self._leveldata:getLayers() ) do
			-- store indices where layers transition
			self._layerindices[index] = layer.name
		
			for i, tile in ipairs(layer.tiles) do
				local _, _, vww, vwh = tile.draw_quad:getViewport()
				if (tile.x > camx - camw - vww and tile.x < camx + camw*2 and
					tile.y > camy - camh - vwh and tile.y < camy + camh*2) then
					table.insert(self._activetiles, tile)
					index = index + 1
				end
			end	
		end
		
		--print("num active tiles: "..#self._activetiles)
		--print("entity draw index: "..self._entitydrawindex)
		
	end
	
end

function Level:draw()

	self._camera:preDraw()
	self._entManager:preDraw()
	
	for k, tile in ipairs(self._activetiles) do
		
		-- draw all entities before the world layer
		if (self._layerindices[k]) then
			self._entManager:draw(self._layerindices[k])
		end
	
		local _, _, vww, vwh = tile.draw_quad:getViewport()
		if (self._camera:isRectInView( tile.x, tile.y, vww, vwh )) then
			local tset = tile.tileset
			love.graphics.drawq( tset.image, tile.draw_quad, tile.x, tile.y )
		end
	end
	
	self._entManager:postDraw()
	self._camera:postDraw()
	
end

function Level:getCamera()
	return self._camera
end

function Level:getPhysicsWorld()
	return self._physworld
end

function Level:createEntity( class, ... )
	return self._entManager:createEntity( class, ...)
end

function Level:removeEntity( ent )
	self._entManager:removeEntity( ent )
end

function Level:getEntitiesByClass( class )
	return self._entManager:getEntitiesByClass( class )
end

function Level:setCollisionCallbacks( beginContact, endContact, preSolve, postSolve )
	self._physworld:setCallbacks( beginContact, endContact, preSolve, postSolve )
end
