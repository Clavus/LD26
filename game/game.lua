
require("game/input_constants")
require("game/sprite_layouts")
require("game/ai_machines")

require("game/classes/rpgplayer")
require("game/classes/zombie")
require("game/classes/speechbubble")

local camera_margin = 64

function game.load()
	
	gui = GUI()
	level = Level(TiledLevelData(FOLDER.ASSETS.."area1"))
	level:setCollisionCallbacks(game.collisionBeginContact, game.collisionEndContact, game.collisionPreSolve, game.collisionPostSolve)

	local pls = level:getEntitiesByClass(Player)
	player = pls[1]
	game.initCamera()
	
	input:addKeyReleaseCallback("restart", "r", function() love.load() end)
	
	print("Game initialized")
	
end

function game.update( dt )

	level:update( dt )
	gui:update( dt )
	
	local cam = level:getCamera()
	local campos = cam:getTargetPos()
	local camw = cam:getWidth()
	local camh = cam:getHeight()
	local plpos = player:getPos()
	
	if (plpos.x < campos.x + camera_margin) then
		cam:moveTo(campos - Vector(camw - 2*camera_margin, 0), 1)
	elseif (plpos.x > campos.x + camw - camera_margin) then
		cam:moveTo(campos + Vector(camw - 2*camera_margin, 0), 1)
	elseif (plpos.y < campos.y + camera_margin) then
		cam:moveTo(campos - Vector(0, camh - 2*camera_margin), 1)
	elseif (plpos.y > campos.y + camh - camera_margin) then
		cam:moveTo(campos + Vector(0, camh - 2*camera_margin), 1)
	end
	
end

function game.draw()

	level:draw()
	gui:draw()
	
end

function game.initCamera()
	
	local cam = level:getCamera()
	local campos = cam:getPos()
	local camw = cam:getWidth()
	local camh = cam:getHeight()
	
	local camgridw = camw - 2*camera_margin
	local camgridh = camh - 2*camera_margin
	
	local plpos = player:getPos()
	
	while (plpos.x < campos.x + camera_margin) do
		campos = campos - Vector(camw - 2*camera_margin,0)
	end
	
	while (plpos.x > campos.x + camw - camera_margin) do
		campos = campos + Vector(camw - 2*camera_margin, 0)
	end
	
	while (plpos.y < campos.y + camera_margin) do
		campos = campos - Vector(0, camh - 2*camera_margin)
	end
	
	while (plpos.y > campos.y + camh - camera_margin) do
		campos = campos + Vector(0, camh - 2*camera_margin)
	end
	
	cam:setPos(campos)
	
end

-- is called by map trigger entities
function game.handleTrigger( other, contact, trigger_type, ...)
	
	if (instanceOf(RPGPlayer, other)) then
		print("Trigger collision!")
		return true
	end
	
	return false
end

-- called upon map load, handle Tiled objects
function game.createLevelEntity( level, entData )
	
	local ent
	if entData.type == "Wall" or entData.type == "Trigger" then
				
		ent = level:createEntity(entData.type, level:getPhysicsWorld(), entData.properties)
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
		
		ent = level:createEntity(entData.type, level:getPhysicsWorld())
		ent:setPos(Vector(entData.x, entData.y))
		
	end
	
end

function game.collisionBeginContact(a, b, contact)
	
	--print("begin contact "..tostring(a:getUserData()).." -> "..tostring(a:getUserData()))
	local ao, bo = a:getUserData(), b:getUserData()
	--print("coll "..tostring(ao).." - "..tostring(bo))
	--print("ao: "..tostring(ao.class)..", incl: "..tostring(includes(CollisionResolver, ao.class)))
	
	if (includes(CollisionResolver, ao.class)) then
		ao:resolveCollisionWith(bo, contact)
	end

	if (includes(CollisionResolver, bo.class)) then
		bo:resolveCollisionWith(ao, contact)
	end
	
	--if (instanceOf(, ao) and instanceOf(RPGPlayer, bo)) then
	--	ao:attackPlayer(bo)
	--elseif (instanceOf(Zombie, bo) and instanceOf(RPGPlayer, ao)) then
	--	bo:attackPlayer(ao)
	--end
	
end

function game.collisionEndContact(a, b, contact)

end

function game.collisionPreSolve(a, b, contact)

end

function game.collisionPostSolve(a, b, contact)

end

