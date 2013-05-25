require 'Game'

-- HARDCODE: load game 'Game'... yeah.
local game

function love.load()
    game = Game:New()
end

function love.update(dt)
    if not game:isPaused() then
        game:update(dt)
    end
end

function love.draw()
    game:draw()
end

function love.keypressed(key)
    game:keyPressed(key)
end

function love.keyreleased(key)
    game:keyReleased(key)
end

function love.mousepressed(x, y, button)
    game:mousePressed(x, y, button)
end

