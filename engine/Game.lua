-- A game contains Waves, a Path, and Tower information

require 'Path'
require 'Wave'
require 'Unit'
require 'Tower'

Game = {
    path = nil,
    objects = {},
    waveNum = 0,
    numLives = 5, -- HARDCODE
    paused = false,
    dtMod = 1,
}

-- TODO refactor into object
local showGameOver = false
local gameOverTime = 0

-- TODO refactor into object
local currentBoxArea = nil

function Game:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    -- HARDCODE
    o.path = o.path or Path:New({ waypoints = {
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

    o.wave = o.wave or Wave:New()
    o.wave:addObjHook(
        function(obj)
            o.objects[#o.objects + 1] = obj
            o.path:addUnits(obj)
        end
    )

    return o
end

function Game:update(dt)
    -- DEBUG allow for faster or slower movement
    dt = dt * self.dtMod

    if self.numLives <= 0 then
        gameOverTime = gameOverTime + dt

        -- toggle GAME OVER
        if gameOverTime > 1.0 then
            showGameOver = not showGameOver
            gameOverTime = gameOverTime - 1
        end

        return
    end

    _, finished = self.path:update(dt)
    self.numLives = self.numLives - finished

    if self.numLives <= 0 then
        showGameOver = true
    end

    self.wave:update(dt)

    for _, o in pairs(self.objects) do
        o:update(dt)
    end
end

function Game:draw()
    self:drawGrid()

    -- Draw interface
    love.graphics.print("Wave " .. self.waveNum, 10, 10)
    love.graphics.print("Lives: " .. self.numLives, 310, 10)

    -- Draw path
    self.path:draw()

    for _, o in pairs(self.objects) do
        o:draw()
    end

    if showGameOver then
        local width = love.graphics.getWidth()
        local height = love.graphics.getHeight()
        local font = love.graphics.newFont(48)
        local oldFont = love.graphics.getFont()
        local text = "GAME OVER!"

        love.graphics.setColor(255, 90, 90)
        local lineHeight = font:getLineHeight()
        love.graphics.setFont(font)

        love.graphics.print(text, width / 2 - font:getWidth(text) / 2,
         height / 2 - font:getHeight() / 2)

         love.graphics.setFont(oldFont)
        love.graphics.setColor(255, 255, 255)
    end
end

-- TODO refactor into object
local gridSpace = 50

function Game:drawGrid()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    local w = 0
    local h = 0


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

function Game:isPaused()
    return self.paused
end

function Game:togglePause()
    self.paused = not self.paused
end

function Game:keyPressed(key)
    if key == " " or key == "p" then
        self:togglePause()
    elseif key == "=" then -- DEBUG speed up
        self.dtMod = self.dtMod + 1
    elseif key == "-" then -- DEBUG slow down
        self.dtMod = self.dtMod - 1
    elseif key == "q" then
        love.event.quit()
    else
        print("Player pressed unmapped key: " .. key)
    end
end

function Game:mousePressed(x, y, button)
    if button == "l" then
        local pos = Vec2:New({ x = x - x % gridSpace, y = y - y % gridSpace })

        -- Make sure there's not another tower at pos first
        for _, o in pairs(self.objects) do
            -- TODO is there a better way to do this? I think so
            if o.pos.x == pos.x and o.pos.y == pos.y then
                return
            end
        end

        self.objects[#self.objects + 1] = Tower:New({ pos = pos })
    end
end
