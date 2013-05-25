-- A game contains Waves, a Path, and Tower information

require 'Path'
require 'Waves'
require 'Unit'
require 'Tower'
require 'SlowingTower'
require 'BuffingTower'
require 'Projectile'

Game = {
    path = nil,
    objects = { units = {}, towers = {}, projectiles = {}},
    numLives = 5, -- HARDCODE
    paused = false,
    dtMod = 1,
    drawBackgrounds = false,
    showGameOver = false,
    gameOverTime = 0,
    waves = nil,
    money = 1000,
}


function Game:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    -- HARDCODE
    o.path = o.path or Path:New({ waypoints = {
        pos = Vec2:New({ x = 100, y = 100 }),
        next = {
            pos = Vec2:New({ x = 700, y = 100 }),
            next = {
                pos = Vec2:New({ x = 700, y = 300}),
                next = {
                    pos = Vec2:New({ x = 100, y = 300 }),
                    next = {
                        pos = Vec2:New({ x = 100, y = 500 }),
                        next = {
                            pos = Vec2:New({ x = 700, y = 500 }),
                        }
                    }
                }
            }
        }
    }})

    -- TODO superhax fix it
    local waveHook = function(obj)
        o.objects.units[#o.objects.units + 1] = obj
        o.path:addUnits(obj)
    end

    o.waves = Waves:New()

    for i = 1,5 do
        local wave = Wave:New({ numUnits = 3 * i })
        wave:addObjHook(waveHook)

        o.waves:addWave(wave)
    end

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

    bounty, finished = self.path:update(dt)
    self.numLives = self.numLives - finished
    self.money = self.money + bounty

    if self.numLives <= 0 then
        self.showGameOver = true
    end

    self.waves:update(dt)

    for _, t in pairs(self.objects) do
        for i, o in pairs(t) do
            if o.isAlive and not o:isAlive() then
                table.remove(t, i)
            end

            o:update(dt)
        end
    end
end

function Game:draw()
    self:drawGrid()

    -- Draw interface
    love.graphics.print("Wave " .. self.waves.current, 10, 10)
    love.graphics.print("Lives: " .. self.numLives, 310, 10)
    love.graphics.print("Money: " .. self.money, 690, 10)

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

-- TODO refactor into a view object
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

-- TODO hax to the max
local makeThirdTower = false

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
    elseif key == "b" then
        makeThirdTower = true
    else
        print("Player pressed unmapped key: " .. key)
    end
end

function Game:keyReleased(key)
    if key == "b" then
        makeThirdTower = false
    end
end

function Game:createTowerAt(pos, TowerClass)
    if self.money < TowerClass.cost then
        return nil
    end

    local offset = Vec2:New({ x = gridSpace / 2, y = gridSpace / 2 })

    -- Make sure there's not another tower at pos first
    for _, o in pairs(self.objects.towers) do
        -- TODO is there a better way to do this? I think so
        if o.pos.x == pos.x + offset.x and o.pos.y == pos.y + offset.y then
            return nil
        end
    end

    -- Buy the tower
    self.money = self.money - TowerClass.cost

    local tower = TowerClass:New({ pos = pos + offset, masterBulletList = self.objects.projectiles })

    tower.acquireTarget = function()
        tower.target = nil
        tower.targetDistance = nil

        for _, o in pairs(self.objects.units) do
            local dist = tower.pos:distanceTo(o.pos.pos)
            if dist < tower.firingRadius then
                tower.target = o
                tower.targetDistance = dist
                break
            end
        end
    end

    local firstPoint = self.path:getFirstWaypoint()

    -- Check to see if we can be buffed
    if tower.Class ~= BuffingTower then
        for _, o in pairs(self.objects.towers) do
            if o.Class == BuffingTower and o:shouldBuff(tower) then
                tower.buffs[#o.buffs + 1] = o
            end
        end
    end

    self.objects.towers[#self.objects.towers + 1] = tower

    return tower
end

function Game:mousePressed(x, y, button)
    local pos = Vec2:New({ x = x - x % gridSpace, y = y - y % gridSpace })
    local tower = nil

    if button == "l" then
        if makeThirdTower then
            tower = self:createTowerAt(pos, BuffingTower)
            for _, o in pairs(self.objects.towers) do
                if o ~= tower and tower:shouldBuff(o) then
                    o.buffs[#o.buffs + 1] = tower
                end
            end
        else
            tower = self:createTowerAt(pos, Tower)
        end
    elseif button == "r" then
        tower = self:createTowerAt(pos, SlowingTower)
    end
end
