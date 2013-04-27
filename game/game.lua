
require("game/input_constants")
require("game/sprite_layouts")

require("game/classes/rpgplayer")
require("game/classes/zombie")

local level, player

function game.load()
	
	gui = GUI()
	level = Level(TiledLevelData(FOLDER.ASSETS.."area1"))
	
	print("Game initialized")
	
end

function game.update( dt )

	level:update( dt )
	gui:update( dt )
	
end

function game.draw()

	level:draw()
	gui:draw()
	
end

-- called upon map load, handle Tiled objects
function game.createLevelEntity( level, entData )
	
	local ent
	if entData.type == "Wall" then
				
		ent = level:createEntity("Wall", level:getPhysicsWorld())
		if entData.w == nil then
			ent:buildFromPolygon(entData.polygon)
		else
			ent:buildFromSquare(entData.w,entData.h)
		end
		
		ent:setPos(Vector(entData.x, entData.y))
		
	elseif entData.type == "Player" then
		
		ent = level:createEntity("RPGPlayer", level:getPhysicsWorld())
		ent:setPos(Vector(entData.x, entData.y))
		
	elseif entData.type == "Zombie" then
		
		ent = level:createEntity("Zombie", level:getPhysicsWorld())
		ent:setPos(Vector(entData.x, entData.y))
		
	end
	
end
