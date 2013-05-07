

Vec2 = {
    x = 0,
    y = 0,
}

Vec2.__unm = function(op1)
    return Vec2:New({ x = -op1.x, y = -op1.y })
end

Vec2.__add = function(op1, op2)
    return Vec2:New({ x = op1.x + op2.x, y = op1.y + op2.y })
end

-- Note: this returns the vector from op2 to op1
Vec2.__sub = function(op1, op2)
    return Vec2:New({ x = op1.x - op2.x, y = op1.y - op2.y })
end

Vec2.__mul = function(op1, scalar)
    return Vec2:New({ x = op1.x * scalar, y = op1.y * scalar })
end

Vec2.__div = function(op1, scalar)
    if (scalar == 0) then
        print("ERROR! Division of Vec2 by zero")
        print(debug.traceback())
        love.event.quit()
    end
    return Vec2:New({ x = op1.x / scalar, y = op1.y / scalar })
end

Vec2.__tostring = function(o)
    return "{ " .. o.x .. ", " .. o.y .. " }"
end

function Vec2:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Vec2:length()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vec2:distanceTo(dest)
    return (self - dest):length()
end

function Vec2:normalize()
    return self / self:length()
end

function Vec2:angleTo(v)
    return math.atan2(self.y - v.y, self.x - v.x)
end
