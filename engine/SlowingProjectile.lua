require 'Projectile'
require 'Effect'

SlowingProjectile = Projectile:New()

SlowingProjectile.speed = 150
SlowingProjectile.damage = 120
SlowingProjectile.image = love.graphics.newImage("assets/Bullet2.png")

function SlowingProjectile:doDamage(o)
    o:takeDamage(self.damage)
    o:addEffect(Effect:New())
end
