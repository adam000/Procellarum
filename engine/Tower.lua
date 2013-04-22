-- A tower represents a stationary object

Tower = {
    target = nil,
    imageRoot = "assets/Tower1/",
    image = love.graphics.newImage("assets/Tower1/North.png"),
    rot = 0,
    pos = Vec2:New(),
}

function Tower:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Tower:update(dt)
end

function Tower:draw()
    love.graphics.draw(self.image, self.pos.x, self.pos.y, self.rot)
end

