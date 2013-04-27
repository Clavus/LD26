
FiniteStateMachine = class("FiniteStateMachine")

--[[
Example machine description:

desc = {
	states = { "idle", "walk", "attack", "dead" },
	events = { "see player", "killed" },
	links = {
		["idle"] = { ["see_player"] = "attack", ["killed"] = "dead", etc.. [event] = new_state }
		etc..
	}
}

]]--

function FiniteStateMachine:initialize( desc, start_state )
	
	self._description = desc
	self._state = start_state
	
end

function FiniteStateMachine:triggetEvent( event )
	
	local links = self._description.links[self._state]
	if (links[event]) then
		self._state = links[event]
	end
	
end

function FiniteStateMachine:getState()

	return self._state	
	
end
