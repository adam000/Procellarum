-- A SlowingTower will slow down passing enemy units

require 'Tower'
require 'SlowingProjectile'

-- Prototypical inheritance
SlowingTower = Tower:New()

SlowingTower.Class = SlowingTower

SlowingTower.cost = 350
SlowingTower.image = love.graphics.newImage("assets/Tower2/North.png")
SlowingTower.fireRate = 1.8
SlowingTower.firingRadius = 150
SlowingTower.bulletType = SlowingProjectile

