-- Effects that get applied to Units or Towers

Effect = {
    timeDistort = 0.7,
    duration = 1.0,
}

function Effect:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    o.timeLeft = self.duration

    return o
end

function Effect:update(dt)
    self.timeLeft = self.timeLeft - dt
end

function Effect:effect(dt)
    return dt * self.timeDistort
end

function Effect:expired()
    return self.timeLeft <= 0
end
