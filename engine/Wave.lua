require 'Unit'

Wave = {
    spawnGap = 1.0,
    timer = 1.0,
    unit = Unit,
    numUnits = 10,
    addObjHook = nil,
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
    if (self:shouldSpawn()) then
        self.hook(self.unit:New())
        self.timer = self.timer - self.spawnGap
        self.numUnits = self.numUnits - 1
    end
end

