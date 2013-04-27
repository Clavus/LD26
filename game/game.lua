
require("game/input_constants")

local cur_level
local player

function game.load()
	
	cur_level = Level(TiledLevelData(FOLDER.ASSETS.."area1"))
	
	local pls = cur_level:getEntitiesByClass(Player)
	player = pls[1]
	
	print("Game initialized")
	
end

function game.update( dt )

	cur_level:update( dt )

end

function game.draw()

	cur_level:draw()
	
end