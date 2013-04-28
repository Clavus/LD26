
EntityManager = class("EntityManager")

function EntityManager:initialize()
	
	self._entities = {}
	--print(table.toString(self._entities, "entities", true))
	self._drawlist = {}
	
	self._update_drawlist = true
	
end

function EntityManager:loadLevelObjects( level, levelobjects )
	
	if (levelobjects and game.createLevelEntity) then
	
		for i,v in ipairs(levelobjects) do
			game.createLevelEntity(level, v)
		end
		
	end
	
end

function EntityManager:createEntity( class, ...)
	
	--print("Creating entity of "..tostring(class))
	
	local ent
	if (_G[class] and subclassOf(Entity, _G[class])) then
		ent = _G[class](...)
	end
	
	if (ent ~= nil and instanceOf(_G[class], ent)) then
		table.insert(self._entities, ent)
		self._update_drawlist = true
		return ent
	else
		return nil
	end
	
end

function EntityManager:removeEntity( ent )
	
	table.removeByValue(self._entities, ent)
	self._update_drawlist = true
	
end

function EntityManager:update( dt )
	
	for k, v in ipairs( self._entities ) do
		v:update( dt )
	end
	
end

function EntityManager:preDraw()
	
	-- created sorted drawing lists per layer for entities
	if (self._update_drawlist) then
	
		self._drawlist = { _final = {} }
		local layer
		
		for k, ent in pairs( self._entities ) do
			layer = ent:getDrawLayer()
			if (layer == DRAW_LAYER_TOP) then
				table.insert(self._drawlist._final, ent)
			else
				if not self._drawlist[layer] then
					self._drawlist[layer] = {} 
				end
				table.insert(self._drawlist[layer], ent)
			end
		end
		
		for k, v in pairs( self._drawlist ) do
			table.sort( self._drawlist[k], function(a, b) return a:getDepth() > b:getDepth() end )
		end
		
		self._update_drawlist = false
		
	end
	
end

-- draw all entities in the given layer
function EntityManager:draw( layer )
	
	if (self._drawlist[layer]) then
		for i, ent in ipairs( self._drawlist[layer] ) do
			ent:draw()
		end
	end
	
end

-- draw all entities that want to be above everything else
function EntityManager:postDraw()
	
	for i, ent in ipairs( self._drawlist._final ) do
		ent:draw()
	end
	
end

function EntityManager:getEntitiesByClass( cl )

	local res = {}
	for k, v in ipairs( self._entities ) do
		if (instanceOf(cl, v)) then
			table.insert(res, v)
		end
	end
	return res
	
end
