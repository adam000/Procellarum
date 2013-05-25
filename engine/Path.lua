require 'Util'
require 'math/Vec2'
require 'Position'

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

function Path:getFirstWaypoint()
    return self.waypoints
end

function Path:addUnits(...)
    for _, o in pairs({...}) do
        -- local obj = {
        --     prev = self.waypoints.pos,
        --     destination = self.waypoints.next,
        --     unit = o,
        -- }

        -- obj.unit.pos = Vec2:New(self.waypoints.pos)
        -- self.units[#self.units + 1] = obj

        o.pos = Position:New({ pos = self:getFirstWaypoint().pos, path = self, unit = o })

        self.units[#self.units + 1] = o
    end
end

function Path:update(dt)
    local numFinished = 0
    local killBounty = 0

    for i, o in pairs(self.units) do
        if not o:isAlive() then
            table.remove(self.units, i)
            if o.finished then
                numFinished = numFinished + 1
            else
                killBounty = killBounty + o.reward
            end
        end
    end

    -- TOOD actually implement numFinished???
    return killBounty, numFinished
end

function Path:draw()
    local line = self.waypoints

    love.graphics.setColor(100, 255, 100)

    while (line.next) do
        love.graphics.line(line.pos.x, line.pos.y, line.next.pos.x, line.next.pos.y)
        line = line.next
    end

    love.graphics.setColor(255, 255, 255)
end
