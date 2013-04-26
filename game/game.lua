
require("game/constants")

local cur_level

function game.load()
	
	cur_level = Level()
	
end

function game.update( dt )

	cur_level:update( dt )

end

function game.draw()

	cur_level:draw()
	
end