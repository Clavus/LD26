
Level = class('Level')

function Level:initialize( leveldata )

	self._leveldata = leveldata
	self._camera = Camera()
	
	love.physics.setMeter(1)
    self._physworld = love.physics.newWorld(0, 10, false)
	self._physworld:setCallbacks(self._beginContact, self._endContact, self._preSolve, self._postSolve)
	
	local objects = nil
	if (leveldata) then
		objects = leveldata.objects
	end
	
	self._entManager = EntityManager(self._physworld, objects)
	
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

--[[ Mattijs code ]]--
function Level:_beginContact(a,b,coll) end
function Level:_endContact(a,b,coll) end
function Level:_preSolve(a,b,coll) end
function Level:_postSolve(a,b,coll) end
--[[ end Mattijs code ]]--