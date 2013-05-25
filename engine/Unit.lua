require 'math/Vec2'

local static = {
    id = 0
}

Unit = {
    alive = true,
    image = love.graphics.newImage("assets/Ghost1.png"),
    velocity = 85,
    rot = 0,
    pos = nil,
    health = 1000,
    reward = 50,
    effects = {},
    finished = false,
}

function Unit:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    o.id = static.id
    static.id = static.id + 1

    return o
end

function Unit:isAlive()
    return self.alive
end

function Unit:kill()
    self.alive = false
end

function Unit:finish()
    self.alive = false
    -- TODO kind of a hack, make more OO
    self.finished = true
end

function Unit:animate(dt)
    self.rot = self.rot + dt
end

function Unit:takeDamage(ptsDmg)
    self.health = self.health - ptsDmg

    print(self.id .. " Health is now " .. self.health)

    if self.health <= 0 then
        print(self.id .. " Supplode!")
        self:kill()
    end
end

function Unit:update(dt)
    for idx, e in pairs(self.effects) do
        e:update(dt)
    end

    dt = self:applyEffects(dt)

    if self:isAlive() then
        self:animate(dt)
    end

    self.pos:update(dt)
end

function Unit:applyEffects(dt)
    for idx, e in pairs(self.effects) do
        if (e:expired()) then
            table.remove(self.effects, idx)
        else
            -- TODO make effects stack
            return e:effect(dt)
        end
    end

    return dt
end

function Unit:addEffect(e)
    self.effects[#self.effects + 1] = e
end

function Unit:draw()
    local image = self.image
    love.graphics.draw(image, self.pos.pos.x, self.pos.pos.y, self.rot, 1, 1, image:getWidth() / 2, image:getHeight() / 2)
end
