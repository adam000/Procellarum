-- A tower represents a stationary object

Tower = {
    bulletHook = nil,
    masterBulletList = nil, -- TODO hack fix this
    bulletList = {},
    target = nil,
    targetDistance = nil,
    acquireTarget = nil,
    imageRoot = "assets/Tower1/",
    image = love.graphics.newImage("assets/Tower1/North.png"),
    rot = 0,
    pos = Vec2:New(),
    fireRate = 1.2, -- TODO abstract this out to a "weapon" on a tower
    firingRadius = 200,
    spinup = 0,
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

        -- Create the bullet
        bullet = Projectile:New({ target = self.target, pos = self.pos })
        self.bulletList[#self.bulletList + 1] = bullet
        self.masterBulletList[#self.masterBulletList + 1] = bullet

        -- Cleanup
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

    -- b is for bullet
    for i, b in pairs(self.bulletList) do
        if not b.target:isAlive() then
            table.remove(self.bulletList, i)

            for k, v in pairs(self.masterBulletList) do
                if v == b then
                    table.remove(self.masterBulletList, k)
                    break
                end
            end
        end

        targetVec = b.target.pos - b.pos
        if targetVec:length() < dt * b.speed then
            -- Kaboom! collision
            print("Kaboom!")
            b:doDamage(b.target)

            table.remove(self.bulletList, i)

            for k, v in pairs(self.masterBulletList) do
                if v == b then
                    table.remove(self.masterBulletList, k)
                    break
                end
            end
            return
        else
            b.pos = b.pos + targetVec:normalize() * dt * b.speed
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

