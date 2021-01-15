-- Author: Ozéias Souza
-- Data: 13/01/2021
-- Hours:  11:45:39

local vec2D = {}

function vec2D.new(x, y)
    local instance = setmetatable({x = x, y = y}, vec2D)

    function instance.distToPoint(self, A)
        return math.sqrt( (A.x - self.x)^2 + (A.y - self.y)^2 )
    end
    
    function instance.rotate(self, angle)
        local xx = self.x * math.cos(angle) - self.y * math.sin(angle)
        local yy = self.x * math.sin(angle) + self.y * math.cos(angle)          
        return vec2D.new(xx, yy)      
    end

    return instance
end

-- Vectors Operations

function vec2D.__add(u, v)    
    return vec2D.new(u.x + v.x, u.y + v.y)
end

function vec2D.__sub(u, v)    
    return vec2D.new(u.x - v.x, u.y - v.y)
end

function vec2D.__mul(u, v)    
    return vec2D.new(u.x * v.x, u.y * v.y)
end

function vec2D.__dot(u, v)    
    return u.x * v.x + u.y * v.y
end

function vec2D.__tos(u)
    return "<"..tostring(u.x)..","..tostring(u.y)..">"
end

-- operator +
vec2D.__add = vec2D.__add
-- operator -
vec2D.__sub = vec2D.__sub
-- operator *
vec2D.__mul = vec2D.__mul
-- operator %
vec2D.__mod = vec2D.__dot
-- print
vec2D.__tostring = vec2D.tos

return vec2D