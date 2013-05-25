require 'Unit'

Wave = {
    spawnGap = 1.0,
    timer = 1.0,
    unit = Unit,
    numUnits = 10,
    units = {},
    hook = nil,
}

function Wave:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Wave:addObjHook(hook)
    self.hook = hook
end

function Wave:shouldSpawn()
    return self.timer > self.spawnGap and self.numUnits > 0
end

function Wave:update(dt)
    self.timer = self.timer + dt

    if self:shouldSpawn() then
        local newUnit = self.unit:New()

        self.hook(newUnit)
        self.units[#self.units + 1] = newUnit

        self.timer = self.timer - self.spawnGap
        self.numUnits = self.numUnits - 1
    end

    -- Check for, and eliminate, dead units
    for i, o in pairs(self.units) do
        if not o:isAlive() then
            table.remove(self.units, i)
        end
    end

    if self.numUnits == 0 and #self.units == 0 then
        -- wave has ended
        return false
    end

    return true
end

