require 'Util'
require 'math/Vec2'

Path = {
    start = Vec2:New(),
    finish = Vec2:New(),
    units = {},
}

function Path:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Path:setStart(pos)
    self.start = Vec2:New({ x = pos.x, y = pos.y })
end

function Path:setFinish(pos)
    self.finish = Vec2:New({ x = pos.x, y = pos.y })
end

function Path:addUnits(...)
    for _, o in pairs({...}) do
        local unit = { lastPoint = self.start, obj = o }
        unit.obj.pos = Vec2:New({ x = self.start.x, y = self.start.y })
        self.units[#self.units + 1] = unit
    end
end

function Path:update(dt)
    for _, object in pairs(self.units) do
        o = object.obj  -- TODO better name
        if o:isAlive() then
            if o.velocity * dt >= (o.pos - self.finish):length() then
                -- Object reaches its destination. For now, kill it.
                o.pos = Vec2:New({ x = self.finish.x, y = self.finish.y })
                o:kill()
            else
                -- Object has not reached its destination, move along
                local direction = (self.finish - self.start):normalize()
                local movement = direction * (o.velocity * dt)

                o.pos = o.pos + movement
            end
        end
    end
end

function Path:draw()
    love.graphics.line(self.start.x, self.start.y, self.finish.x, self.finish.y)
end
