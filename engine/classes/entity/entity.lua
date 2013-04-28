
Entity = class("Entity")

local entCounter = 0

function Entity:initialize()
	
	self._pos = Vector(0,0)
	self._index = _entIndex
	self._relative_depth = 0
	
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

function Entity:onRemove()

end

-- gets the layer name where this entity is drawn BEFORE
function Entity:getDrawLayer()

	return "world"
	
end

function Entity:getDrawBoundingBox()
	
	local pos = self:getPos()
	return pos.x - 32, pos.y - 32, 64, 64
	
end

function Entity:getDepth()
	
	return -self:getPos().y + self._relative_depth
	
end

function Entity:getEntIndex()
	
	return self._entIndex
	
end

function Entity:__eq( other )
	
	return instanceOf(self.class, other) and self:getEntIndex() == other:getEntIndex()
	
end