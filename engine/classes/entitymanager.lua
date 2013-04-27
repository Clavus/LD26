
EntityManager = class("EntityManager")

function EntityManager:initialize()
	
	self._entities = {}
	--print(table.toString(self._entities, "entities", true))
	
end

function EntityManager:loadLevelObjects( level, levelobjects )
	
	if (levelobjects and game.createLevelEntity) then
	
		for i,v in ipairs(levelobjects) do
			game.createLevelEntity(level, v)
		end
		
	end
	
end

function EntityManager:createEntity( class, ...)
	
	local ent
	if (_G[class] and subclassOf(Entity, _G[class])) then
		ent = _G[class](...)
	end
	
	if (ent ~= nil and instanceOf(_G[class], ent)) then
		table.insert(self._entities, ent)
		return ent
	else
		return nil
	end
	
end

function EntityManager:update( dt )
	
	for k, v in pairs( self._entities ) do
		v:update( dt )
	end
	
end

function EntityManager:draw()
	
	table.sort(self._entities, function(a, b) return a:getPos().y < b:getPos().y end)
	for k, v in pairs( self._entities ) do
		v:draw()
	end

end

function EntityManager:getEntitiesByClass( cl )

	local res = {}
	for k, v in pairs( self._entities ) do
		if (instanceOf(cl, v)) then
			table.insert(res, v)
		end
	end
	return res
	
end