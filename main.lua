
game = {}
engine = {}
require("engine/engine")
require("game/game")

local _curTime

function love.load()
	
	_curTime = 0
	input = InputController()
	game.load()
	
end

function love.update( dt )
	
	_curTime = _curTime + dt
	timer.check()
	game.update( dt )
	input:clear()
	
end

function love.draw()
	
	love.graphics.setBackgroundColor( 130, 205, 190 )
	love.graphics.clear()
	game.draw()
	
end

function love.mousepressed(x, y, button)
	
	input:handle_mousepressed(x,y,button)
	
end

function love.mousereleased(x, y, button)
	
	input:handle_mousereleased(x,y,button)
	
end

function love.keypressed(key, unicode)
	
	input:handle_keypressed(key, unicode)
	
end

function love.keyreleased(key, unicode)
	
	input:handle_keyreleased(key, unicode)
	
end

function love.focus(f)

end

function love.quit()

end

function engine.currentTime()
	
	return _curTime
	
end

