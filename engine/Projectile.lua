
Projectile = {
    image = love.graphics.newImage("assets/Bullet1.png"),
    pos = Vec2:New(),
    speed = 100,
    damage = 500,
    target = nil,
}

function Projectile:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Projectile:update(dt)
end

function Projectile:draw()
    local image = self.image
    love.graphics.draw(image, self.pos.x, self.pos.y, 0, 1, 1,
     image:getWidth() / 2, image:getHeight() / 2)
end

function Projectile:doDamage(o)
    o:takeDamage(self.damage)
end

