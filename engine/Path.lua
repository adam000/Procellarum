require 'Util'
require 'math/Vec2'

Path = {
    waypoints = {},
    units = {},
}

function Path:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

-- Waypoints should be a linked list (using .next) of Vec2s to represent a line
function Path:setWaypoints(waypoints)
    self.waypoints = waypoints
end

function Path:addUnits(...)
    for _, o in pairs({...}) do
        local obj = {
            prev = self.waypoints.loc,
            destination = self.waypoints.next,
            unit = o,
        }

        obj.unit.pos = Vec2:New(self.waypoints.loc)
        self.units[#self.units + 1] = obj
    end
end

function Path:update(dt)
    local numFinished = 0
    local numKilled = 0

    for idx, obj in pairs(self.units) do
        local o = obj.unit
        local prev = obj.prev
        local dest = obj.destination.loc

        if o:isAlive() then
            if o.velocity * dt >= (o.pos - dest):length() then
                -- Object reaches its destination.
                o.pos = Vec2:New(dest)

                -- If it's the end of the line, kill it
                if not obj.destination.next then
                    o:kill()
                    numFinished = numFinished + 1
                else
                    -- Otherwise, switch focus to the next waypoint
                    obj.prev = obj.destination.loc
                    obj.destination = obj.destination.next
                end
            else
                -- Object has not reached its destination, move along
                local direction = (dest - prev):normalize()
                local movement = direction * (o.velocity * dt)

                o.pos = o.pos + movement
            end
        else
            numKilled = numKilled + 1
            table.remove(self.units, idx)
        end
    end

    return numKilled, numFinished
end

function Path:draw()
    local line = self.waypoints

    love.graphics.setColor(100, 255, 100)

    while (line.next) do
        love.graphics.line(line.loc.x, line.loc.y, line.next.loc.x, line.next.loc.y)
        line = line.next
    end

    love.graphics.setColor(255, 255, 255)
end
