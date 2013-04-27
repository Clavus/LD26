
Entity = class("Entity")

local entCounter = 0

function Entity:initialize()
	
	self._pos = Vector(0,0)
	self._index = _entIndex
	
	entCounter = entCounter + 1
	self._entIndex = entCounter
	
end

function Entity:setPos( vec )
	
	assert(vec.class.name == "Vector", "Vector expected, got "..type(vec))
	self._pos = vec

end

function Entity:getPos()

	return self._pos:copy()

end

function Entity:update( dt )

end

function Entity:draw()

end

function Entity:getEntIndex()
	
	return self._entIndex
	
end