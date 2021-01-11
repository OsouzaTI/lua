local Module = {}

function Module.new(x, y, z)
    return setmetatable({x = x, y = y, z = z}, Module)
end

-- Vectors Operations

function Module.add(u, v)    
    return Module.new(u.x + v.x, u.y + v.y, u.z + v.z)
end

function Module.sub(u, v)    
    return Module.new(u.x - v.x, u.y - v.y, u.z - v.z)
end

function Module.mul(u, v)    
    return Module.new(u.x * v.x, u.y * v.y, u.z * v.z)
end

function Module.dot(u, v)    
    return u.x * v.x + u.y * v.y + u.z * v.z
end

function Module.tos(u)
    return "<"..tostring(u.x)..","..tostring(u.y)..","..tostring(u.z)..">"
end


Module.__add = Module.add
Module.__sub = Module.add
Module.__mul = Module.add
Module.__mod = Module.dot
Module.__tostring = Module.tos

return Module