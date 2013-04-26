
EntityManager = class("EntityManager")

function EntityManager:initialize( physworld, levelobjects )
	
	self._entities = {}
	
	local wallCounter = 1
	
	if (levelobjects) then
	
		for i,v in ipairs(levelobjects) do
		
			local ent
			
			if v.type == "Wall" then
				
				ent = Wall(physworld)
				if v.w == nil then
					ent:buildFromPolygon(v.polygon)
				else
					ent:buildFromSquare(v.w,v.h)
				end
				
				ent:setPos(Vector(v.x, v.y))
				
			elseif v.type == "Player" then
				
				ent = Player(physworld)
				ent:setPos(Vector(v.x, v.y))
				
			end
			
			table.insert(self._entities, ent)
			
		end
		
	end
	
end

function EntityManager:update( dt )
	
	for k, v in pairs( self._entities ) do
		v:update( dt )
	end
	
end

function EntityManager:draw()

	for k, v in pairs( self._entities ) do
		v:draw()
	end

end