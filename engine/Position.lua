-- A Position is a location along a Path. Used to direct a Unit (a Unit contains
-- a Position on a Path)
--
-- So a Position delegates between Unit and Path. Unit says "I am moving x" and
-- path says "your new location is y"

Position = {
    prevPoint = nil,
    pos = nil,
    unit = nil,
    path = nil,
}

function Position:New(o)
    -- TODO why does this not work
    if not o or not o.path or not o.unit then
        exit("Error! Must supply argument to Position constructor with path and unit args")
    end

    o.prevPoint = o.path:getFirstWaypoint()

    setmetatable(o, self)
    self.__index = self
    return o
end

function Position:update(dt)
    local prev = self.prevPoint
    local dest = self.prevPoint.next
    local o = self.unit

    if not o:isAlive() or not dest then
        -- print("This shouldn't happen!!!!!!!!!!!")
        return
    end

    if o.velocity * dt >= (self.pos - dest.pos):length() then
        -- Object reaches its destination.
        -- Approximate new position
        -- TODO continue on new vector after this
        self.pos = Vec2:New(dest.pos)

        if not dest.next then
            -- If it's the end of the line, kill it
            o:finish()
        else
            -- Otherwise, switch focus to the next waypoint
            self.prevPoint = self.prevPoint.next
        end
    else
        -- Object has not reached its destination, move along
        local direction = (dest.pos - prev.pos):normalize()
        local movement = direction * (o.velocity * dt)

        self.pos = self.pos + movement
    end
end
