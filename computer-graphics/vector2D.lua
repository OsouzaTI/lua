local vec2 = {}

function vec2.new(x, y)
    return setmetatable({x = x, y = y}, vec2)
end

-- Vectors Operations

function vec2.add(u, v)    
    return vec2.new(u.x + v.x, u.y + v.y)
end

function vec2.sub(u, v)    
    return vec2.new(u.x - v.x, u.y - v.y)
end

function vec2.mul(u, v)    
    return vec2.new(u.x * v.x, u.y * v.y)
end

function vec2.dot(u, v)    
    return u.x * v.x + u.y * v.y
end

function vec2.tos(u)
    return "<"..tostring(u.x)..","..tostring(u.y)..">"
end

function vec2.distancePoint(a, b)
    return math.sqrt( (b.x - a.x)^2 + (b.y - a.y)^2 )
end

vec2.__add = vec2.add
vec2.__sub = vec2.add
vec2.__mul = vec2.add
vec2.__mod = vec2.dot
vec2.__tostring = vec2.tos

return vec2