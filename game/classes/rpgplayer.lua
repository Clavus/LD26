
RPGPlayer = class("RPGPlayer", Player)

function RPGPlayer:initialize( world )

	Player.initialize(self, world)
	
	local sData = SpriteData( FOLDER.ASSETS.."char_sheet32.png", Vector(0,0), Vector(32,32), Vector(16,16), 4, 4, 2, true )
	self._sprite = Sprite( sData )
	
end

function RPGPlayer:update( dt )
	
	self._sprite:update(dt)
	
end

function RPGPlayer:draw()
	
	local pos = self:getPos()
	self._sprite:draw(pos.x, pos.y)
	
end