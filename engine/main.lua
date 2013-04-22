require 'Game'

-- HARDCODE: load game 'Game'... yeah.
local game

local paused = false

function love.load()
    game = Game:New()
end

function love.update(dt)
    if not paused then
        game:update(dt)
    end
end

function love.draw()
    game:draw()
end
