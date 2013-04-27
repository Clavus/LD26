--[[
Input controller

bool InputController:keyWasPressed(key)
bool InputController:keyWasReleased(key)
bool InputController:mouseWasPressed(button)
bool InputController:mouseWasReleased(button)

void InputController:addKeyPressCallback(id, key, func) -- callback = func(key)
void InputController:addKeyReleaseCallback(id, key, func) -- callback = func(key, timediff)
void InputController:addMousePressCallback(id, button, func) -- callback = func(button)
void InputController:addMouseReleaseCallback(id, button, func) -- callback = func(button, timediff)

void InputController:removeKeyPressCallback(id)
void InputController:removeKeyReleaseCallback(id)
void InputController:removeMousePressCallback(id)
void InputController:removeMouseReleaseCallback(id)
]]--

InputController = class("InputController")

function InputController:initialize()
	
	self._keysdown = {}
	self._mousedown = {}
	self._keyspressed = {}
	self._mousepressed = {}
	self._keysreleased = {}
	self._mousereleased = {}
	
	self._keypresscalls = {}
	self._keyreleasecalls = {}
	self._mousepresscalls = {}
	self._mousereleasecalls = {}
	
end

function InputController:clear()

	self._keyspressed = {}
	self._mousepressed = {}
	self._keysreleased = {}
	self._mousereleased = {}
	
end

function InputController:keypressed(key, unicode)
	
	--print("key "..key.." pressed "..tostring(unicode))
	self._keyspressed[key] = true
	self._keysdown[key] = { time = love.currentTime() }
	
	if (self._keypresscalls[key]) then
		for k, v in pairs(self._keypresscalls[key]) do
			v.func(key)
		end
	end
	
end

function InputController:keyreleased(key, unicode)

	--print("key "..key.." released "..tostring(unicode))
	self._keysreleased[key] = false
	
	if (self._keyreleasecalls[key]) then
		for k, v in pairs(self._keyreleasecalls[key]) do
			v.func(key, love.currentTime() - self._keysdown[key].time)
		end
	end
	
	self._keysdown[key] = nil
	
end

function InputController:mousepressed(x, y, button)
	
	self._mousepressed[button] = true
	self._mousedown[button] = { x = x, y = y, time = love.currentTime() }
	
	if (self._mousepresscalls[button]) then
		for k, v in pairs(self._mousepresscalls[button]) do
			v.func(x, y)
		end
	end
	
end

function InputController:mousereleased(x, y, button)
	
	self._mousereleased[button] = true
	
	if (self._mousereleasecalls[button]) then
		for k, v in pairs(self._mousereleasecalls[button]) do
			v.func(x, y, love.currentTime() - self._mousedown[button].time)
		end
	end
	
	self._mousedown[button] = nil
	
end

function InputController:keyWasPressed(key)
	
	if (self._keyspressed[key]) then return true
	else return false end
	
end

function InputController:keyWasReleased(key)
	
	if (self._keysreleased[key]) then return true
	else return false end
	
end

function InputController:mouseWasPressed(button)
	
	if (self._mousepressed[key]) then return true
	else return false end
	
end

function InputController:mouseWasReleased(button)
	
	if (self._mousereleased[key]) then return true
	else return false end
	
end

function InputController:addKeyPressCallback(id, key, func)

	if not self._keypresscalls[key] then
		self._keypresscalls[key] = {}
	end

	self._keypresscalls[key][id] = func
	
end

function InputController:removeKeyPressCallback(id)
	
	for k, v in pairs(self._keypresscalls) do
		if (v[id]) then
			self._keypresscalls[k][id] = nil
		end
	end
	
end

function InputController:addKeyReleaseCallback(id, key, func)

	if not self._keyreleasecalls[key] then
		self._keyreleasecalls[key] = {}
	end

	self._keyreleasecalls[key][id] = func
	
end

function InputController:removeKeyReleaseCallback(id)

	for k, v in pairs(self._keyreleasecalls) do
		if (v[id]) then
			self._keyreleasecalls[k][id] = nil
		end
	end
	
end

function InputController:addMousePressCallback(id, button, func)

	if not self._mousepresscalls[button] then
		self._mousepresscalls[button] = {}
	end

	self._mousepresscalls[button][id] = func
	
end

function InputController:removeMousePressCallback(id)
	
	for k, v in pairs(self._mousepresscalls) do
		if (v[id]) then
			self._mousepresscalls[k][id] = nil
		end
	end

end

function InputController:addMouseReleaseCallback(id, button, func)

	if not self._mousereleasecalls[button] then
		self._mousereleasecalls[button] = {}
	end

	self._mousereleasecalls[button][id] = func
	
end

function InputController:removeMouseReleaseCallback(id)

	for k, v in pairs(self._mousereleasecalls) do
		if (v[id]) then
			self._mousereleasecalls[k][id] = nil
		end
	end
	
end