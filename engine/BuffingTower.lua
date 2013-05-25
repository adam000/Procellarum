-- A BuffingTower will boost the rate of fire of nearby towers

require 'Tower'

-- Prototypical inheritance
BuffingTower = Tower:New()

BuffingTower.Class = BuffingTower

BuffingTower.cost = 450
BuffingTower.image = love.graphics.newImage("assets/Tower3.png")
BuffingTower.fireRate = 0.0 -- edge case! Don't *always* fire. Rather, *never* fire
-- TODO this really should just be called radius
BuffingTower.firingRadius = 175


function BuffingTower:update(dt)
end

function BuffingTower:fireBullet()
    error("This should never be called")
end

function BuffingTower:updateBullets(dt)
    error("This should never be called")
end

function BuffingTower:drawBackground()
    -- background is always drawn, so don't use this function
end

function BuffingTower:shouldBuff(otherTower)
    return self.pos:distanceTo(otherTower.pos)
end

-- TODO hax this and other modifiers should be closures
function BuffingTower:buff(otherTower, dt)
    return dt * 2.0
end

function BuffingTower:draw()
    local image = self.image
    love.graphics.draw(image, self.pos.x, self.pos.y, self.rot, 1, 1,
     image:getWidth() / 2, image:getHeight() / 2)

     -- yellowish aura
     love.graphics.setColor(175, 175, 90, 100)
     love.graphics.circle("fill", self.pos.x, self.pos.y, self.firingRadius)
     love.graphics.setColor(255, 255, 255, 255)
end
