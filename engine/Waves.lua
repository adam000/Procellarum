-- Multiple waves. Basically what it sounds like.
-- Child classes could do things like allow the next wave to start early or name
-- individual waves.

require 'Wave'

Waves = {
    waves = {},
    current = 1,
}

function Waves:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Waves:addWave(wave)
    self.waves[#self.waves + 1] = wave
end

function Waves:update(dt)
    if self.current > #self.waves then
        -- Victory! TODO
        love.event.quit()
        return
    end

    local currentWave = self.waves[self.current]

    if not currentWave:update(dt) then
        -- this wave is over
        self.current = self.current + 1
    end
end
