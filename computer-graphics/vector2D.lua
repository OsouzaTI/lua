local Module = {}

function Module.new(x, y)
    return setmetatable({x = x, y = y}, Module)
end

-- Vectors Operations

function Module.add(u, v)    
    return Module.new(u.x + v.x, u.y + v.y)
end

function Module.sub(u, v)    
    return Module.new(u.x - v.x, u.y - v.y)
end

function Module.mul(u, v)    
    return Module.new(u.x * v.x, u.y * v.y)
end

function Module.dot(u, v)    
    return u.x * v.x + u.y * v.y
end

function Module.tos(u)
    return "<"..tostring(u.x)..","..tostring(u.y)..">"
end

function Module.distancePoint(a, b)
    return math.sqrt( (b.x - a.x)^2 + (b.y - a.y)^2 )
end

Module.__add = Module.add
Module.__sub = Module.add
Module.__mul = Module.add
Module.__mod = Module.dot
Module.__tostring = Module.tos

return Module