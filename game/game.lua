
require("game/input_constants")
require("game/sprite_layouts")

require("game/classes/rpgplayer")
require("game/classes/zombie")

local level, player
local camera_margin = 64

function game.load()
	
	gui = GUI()
	level = Level(TiledLevelData(FOLDER.ASSETS.."area1"))
	
	local pls = level:getEntitiesByClass(Player)
	player = pls[1]
	
	print(tostring(player))
	print("Game initialized")
	
end

function game.update( dt )

	level:update( dt )
	gui:update( dt )
	
	local cam = level:getCamera()
	local campos = cam:getTargetPos()
	local plpos = player:getPos()
	
	print("cam "..tostring(cam:getPos())..", player "..tostring(plpos))
	
	if (plpos.x < campos.x + camera_margin) then
		cam:moveTo(campos - Vector(love.graphics.getWidth() - 2*camera_margin, 0), 1)
	elseif (plpos.x > campos.x + love.graphics.getWidth() - camera_margin) then
		cam:moveTo(campos + Vector(love.graphics.getWidth() - 2*camera_margin, 0), 1)
	elseif (plpos.y < campos.y + camera_margin) then
		cam:moveTo(campos - Vector(0, love.graphics.getHeight() - 2*camera_margin), 1)
	elseif (plpos.y > campos.y + love.graphics.getHeight() - camera_margin) then
		cam:moveTo(campos + Vector(0, love.graphics.getHeight() - 2*camera_margin), 1)
	end
	
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
