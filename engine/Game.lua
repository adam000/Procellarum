-- A game contains Waves, a Path, and Tower information

require 'Path'
require 'Wave'
require 'Unit'
require 'Tower'
require 'Projectile'

Game = {
    path = nil,
    objects = { units = {}, towers = {}, projectiles = {}},
    waveNum = 0,
    numLives = 5, -- HARDCODE
    paused = false,
    dtMod = 1,
    drawBackgrounds = false,
    showGameOver = false,
    gameOverTime = 0,
}


function Game:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    -- HARDCODE
    o.path = o.path or Path:New({ waypoints = {
        loc = Vec2:New({ x = 100, y = 100 }),
        next = {
            loc = Vec2:New({ x = 700, y = 100 }),
            next = {
                loc = Vec2:New({ x = 700, y = 300}),
                next = {
                    loc = Vec2:New({ x = 100, y = 300 }),
                    next = {
                        loc = Vec2:New({ x = 100, y = 500 }),
                        next = {
                            loc = Vec2:New({ x = 700, y = 500 }),
                        }
                    }
                }
            }
        }
    }})

    o.wave = o.wave or Wave:New()
    o.wave:addObjHook(
        function(obj)
            o.objects.units[#o.objects.units + 1] = obj
            o.path:addUnits(obj)
        end
    )

    return o
end

function Game:update(dt)
    -- DEBUG allow for faster or slower movement
    dt = dt * self.dtMod

    if self.numLives <= 0 then
        self.gameOverTime = self.gameOverTime + dt

        -- toggle GAME OVER
        if self.gameOverTime > 1.0 then
            self.showGameOver = not self.showGameOver
            self.gameOverTime = self.gameOverTime - 1
        end

        return
    end

    _, finished = self.path:update(dt)
    self.numLives = self.numLives - finished

    if self.numLives <= 0 then
        self.showGameOver = true
    end

    self.wave:update(dt)

    for _, t in pairs(self.objects) do
        for _, o in pairs(t) do
            o:update(dt)
        end
    end
end

function Game:draw()
    self:drawGrid()

    -- Draw interface
    love.graphics.print("Wave " .. self.waveNum, 10, 10)
    love.graphics.print("Lives: " .. self.numLives, 310, 10)

    -- Draw object backgrounds
    if self.drawBackgrounds then
        for _, t in pairs(self.objects) do
            for _, o in pairs(t) do
                if o.drawBackground then
                    o:drawBackground()
                end
            end
        end
    end

    -- Draw path
    self.path:draw()

    -- Draw objects
    for _, t in pairs(self.objects) do
        for _, o in pairs(t) do
            o:draw()
        end
    end

    if self.showGameOver then
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

function Game:targetProgressing(tower)
    return function()
        tower.target = nil
        tower.targetDistance = nil

        for _, o in pairs(self.objects.units) do
            if o:isAlive() then
                local dist = tower.pos:distanceTo(o.pos)
                if dist < tower.firingRadius then
                    tower.target = o
                    tower.targetDistance = dist
                    break
                end
            end
        end
    end
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
        self.dtMod = self.dtMod * 2
    elseif key == "-" then -- DEBUG slow down
        self.dtMod = self.dtMod / 2
    elseif key == "q" then
        love.event.quit()
    elseif key == "t" then
        self.drawBackgrounds = not self.drawBackgrounds
    else
        print("Player pressed unmapped key: " .. key)
    end
end

function Game:mousePressed(x, y, button)
    if button == "l" then
        local pos = Vec2:New({ x = x - x % gridSpace, y = y - y % gridSpace })

        -- Make sure there's not another tower at pos first
        for _, o in pairs(self.objects.towers) do
            -- TODO is there a better way to do this? I think so
            if o.pos.x == pos.x + 25 and o.pos.y == pos.y + 25 then
                return
            end
        end

        local offset = Vec2:New({ x = 25, y = 25 })

        local tower = Tower:New({ pos = pos + offset, masterBulletList = self.objects.projectiles })
        tower.acquireTarget = self:targetProgressing(tower)
        self.objects.towers[#self.objects.towers + 1] = tower
    end
end
