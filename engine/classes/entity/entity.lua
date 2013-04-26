
Entity = class("Entity")

local _entIndex = 1

function Entity:initialize()
	
	self._pos = Vector(0,0)
	self._index = _entIndex
	
	_entIndex = _entIndex + 1
	
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
	
	return _entIndex
	
end