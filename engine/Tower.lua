-- A tower represents a stationary object

Tower = {
    target = nil,
    targetDistance = nil,
    acquireTarget = nil,
    imageRoot = "assets/Tower1/",
    image = love.graphics.newImage("assets/Tower1/North.png"),
    rot = 0,
    fireRate = 3,
    firingRadius = 75,
    spinup = 0,
    pos = Vec2:New(),
}

function Tower:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Tower:update(dt)
    self.spinup = self.spinup + dt

    self:acquireTarget()

    if self.spinup >= self.fireRate and self.target then
        -- Fire!
        print("Pew!")
        self.spinup = 0
        self.target:kill()
        self.target = nil
        self.targetDistance = nil
    else
        -- Point at something
        if not self.target then
            self.rot = 0
        else
            -- TODO why subtract 90 degrees??
            self.rot = self.pos:angleTo(self.target.pos) - math.pi / 2
        end
    end
end

function Tower:drawBackground()
    love.graphics.setColor(255, 100, 100, 100)
    love.graphics.circle("fill", self.pos.x, self.pos.y, self.firingRadius)
    love.graphics.setColor(255, 255, 255, 255)
end

function Tower:draw()
    local image = self.image
    love.graphics.draw(image, self.pos.x, self.pos.y, self.rot, 1, 1,
     image:getWidth() / 2, image:getHeight() / 2)
end

