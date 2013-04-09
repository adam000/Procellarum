require 'Path'
require 'Wave'
require 'Unit'

local objects = {}
local waveNum = 0
local path

function love.load()
    path = Path:New()
    path:setStart( { x = 100, y = 100 } )
    path:setFinish( { x = 400, y =400 } )

    wave = Wave:New()
    wave:addObjHook(
        function(o)
            objects[#objects + 1] = o
            path:addUnits(o)
        end
    );
end

function love.update(dt)
    path:update(dt)

    wave:update(dt)

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
