require 'Path'
require 'Wave'
require 'Unit'

local objects = {}
local waveNum = 0
local path

function love.load()
    path = Path:New({ waypoints = {
                        loc = Vec2:New({ x = 100, y = 100 }),
                        next = {
                            loc = Vec2:New({ x = 400, y = 100 }),
                            next = {
                                loc = Vec2:New({ x = 400, y = 400}),
                                next = {
                                    loc = Vec2:New({ x = 300, y = 500 }),
                                }
                            }
                        }
                    }})

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
    drawGrid()

    -- Draw interface
    love.graphics.print("Wave " .. waveNum, 10, 10)

    -- Draw path
    path:draw()

    for _, o in pairs(objects) do
        o:draw()
    end
end

function drawGrid()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    local w = 0;
    local h = 0;

    local gridSpace = 50

    love.graphics.setColor(180, 180, 200, 200)

    while (w < width) do
        w = w + gridSpace
        love.graphics.line(w, 0, w, height)
    end

    while (h < height) do
        h = h + gridSpace
        love.graphics.line(0, h, width, h)
    end

    love.graphics.setColor(255, 255, 255)
end

