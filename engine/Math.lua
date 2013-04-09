function vecTo(o1, o2)
    local ret = { x = o1.x - o2.x, y = o1.y - o2.y }

    if o1.z and o2.z then
        ret.z = o1.z - o2.z
    end

    return ret
end

function length(vec)
    if vec.z then
        return math.sqrt(vec.x * vec.x + vec.y * vec.y + vec.z * vec.z)
    else
        return math.sqrt(vec.x + vec.x + vec.y * vec.y)
    end
end

function distance(o1, o2)
    return length(vecTo(o1, o2))
end

function normalize(vec)
    local mag = length(vec)
    local ret = { x = vec.x / mag, y = vec.y / mag }

    if vec.z then
        ret.z = vec.z / mag
    end

    return ret
end

