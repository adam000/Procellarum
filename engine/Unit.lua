require 'math/Vec2'

local static = {
    id = 0
}

Unit = {
    alive = true,
    image = love.graphics.newImage("assets/Ghost1.png"),
    velocity = 75,
    rot = 0,
    pos = Vec2:New({ x = 0, y = 0 }),
    health = 1000,
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
    if self:isAlive() then
        self:animate(dt)
    end
end

function Unit:draw()
    if self:isAlive() then
        local image = self.image
        love.graphics.draw(image, self.pos.x, self.pos.y, self.rot, 1, 1, image:getWidth() / 2, image:getHeight() / 2)
    end
end
