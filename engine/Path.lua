require 'Util'
require 'Math'

Path = {
    start = { x = 0, y = 0 },
    finish = { x = 0, y = 0 },
    units = {},
}

function Path:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Path:setStart(pos)
    self.start = { x = pos.x, y = pos.y }
end

function Path:setFinish(pos)
    self.finish = { x = pos.x, y = pos.y }
end

function Path:addUnits(...)
    for _, o in pairs({...}) do
        local unit = { lastPoint = self.start, obj = o }
        unit.obj.pos = { x = self.start.x, y = self.start.y }
        self.units[#self.units + 1] = unit
    end
end

function Path:update(dt)
    for _, object in pairs(self.units) do
        o = object.obj  -- TODO better name
        if o:isAlive() then
            if o.velocity * dt >= distance(o.pos, self.finish) then
                -- Object reaches its destination. For now, kill it.
                o.pos = { x = self.finish.x, y = self.finish.y }
                o:kill()
            else
                -- Object has not reached its destination, move along
                o.pos.x = o.pos.x + normalize(vecTo(self.finish, self.start)).x * o.velocity * dt
                o.pos.y = o.pos.y + normalize(vecTo(self.finish, self.start)).y * o.velocity * dt
            end
        end
    end
end

function Path:draw()
    love.graphics.line(self.start.x, self.start.y, self.finish.x, self.finish.y)
end
