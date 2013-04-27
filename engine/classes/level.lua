
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
	
	self._entitydrawindex = nil
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
			-- draw all entities before the world layer
			if (self._entitydrawindex == nil and layer.name == "world") then
				self._entitydrawindex = index
			end
		
			for i, tile in ipairs(layer.tiles) do
				local _, _, vww, vwh = tile.draw_quad:getViewport()
				if (tile.x > camx - camw - vww and tile.x < camx + camw*2 and
					tile.y > camy - camh - vwh and tile.y < camy + camh*2) then
					table.insert(self._activetiles, tile)
					index = index + 1
				end
			end	
		end
		
		-- if we didn't encounter the world layer, just add it at the end
		if (self._entitydrawindex == nil) then
			self._entitydrawindex = index
		end
		
		print("num active tiles: "..#self._activetiles)
		--print("entity draw index: "..self._entitydrawindex)
		
	end
	
end

function Level:draw()

	self._camera:preDraw()
	
	for k, tile in ipairs(self._activetiles) do
		
		-- draw all entities before the world layer
		if (k == self._entitydrawindex) then
			self._entManager:draw()
		end
	
		local _, _, vww, vwh = tile.draw_quad:getViewport()
		if (self._camera:isRectInView( tile.x, tile.y, vww, vwh )) then
			local tset = tile.tileset
			love.graphics.drawq( tset.image, tile.draw_quad, tile.x, tile.y )
		end
	end
	
	-- draw if we didn't draw it before
	if (self._entitydrawindex > #self._activetiles) then
		self._entManager:draw()
	end
	
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

function Level:getEntitiesByClass( class )

	return self._entManager:getEntitiesByClass( class )
	
end

function Level:_beginContact(a,b,coll) end
function Level:_endContact(a,b,coll) end
function Level:_preSolve(a,b,coll) end
function Level:_postSolve(a,b,coll) end
