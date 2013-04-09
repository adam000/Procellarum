require 'Path'
require 'Unit'

local objects = {}
local waveNum = 0
local path

function love.load()
    path = Path:New()
    path:setStart( { x = 100, y = 100 } )
    path:setFinish( { x = 400, y =400 } )

    unit = Unit:New()
    objects[#objects + 1] = unit
    path:addUnits(unit)
end

function love.update(dt)
    path:update(dt)

    for _, o in pairs(objects) do
        o:update(dt)
    end
end

function love.draw()
    -- Draw interface
    love.graphics.print("Wave " .. waveNum, 10, 10)

    -- Draw path
    path:draw()

    for _, o in pairs(objects) do
        o:draw()
    end
end
