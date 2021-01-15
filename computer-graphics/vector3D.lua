-- Author: Ozéias Souza
-- Data: 13/01/2021
-- Hours:  11:46:51
local vec3D = {}

function vec3D.new(x, y, z)
    local instance = setmetatable({x = x, y = y, z = z}, vec3D)    
    -- multiply a 3D vector a scalar 
    function instance.mulScalar(self, k)    
        self.x = self.x * k
        self.y = self.y * k
        self.z = self.z * k
    end
-- multiply a 3D vector a scalar 
    function instance.sumScalar(self, k)    
        self.x = self.x + k
        self.y = self.y + k
        self.z = self.z + k
    end

    function instance.distToPoint(self, A)
        return math.sqrt( (A.x - self.x)^2 + (A.y - self.y)^2 + (A.z - self.z)^2 )
    end

    return instance
end

-- Vectors Operations

function vec3D.__add(u, v)    
    return vec3D.new(u.x + v.x, u.y + v.y, u.z + v.z)
end

function vec3D.__sub(u, v)    
    return vec3D.new(u.x - v.x, u.y - v.y, u.z - v.z)
end

function vec3D.__mul(u, v)    
    return vec3D.new(u.x * v.x, u.y * v.y, u.z * v.z)
end

function vec3D.__dot(u, v)    
    return u.x * v.x + u.y * v.y + u.z * v.z
end

function vec3D.__tos(u)
    return "<"..tostring(u.x)..","..tostring(u.y)..","..tostring(u.z)..">"
end

vec3D.__add = vec3D.__add
vec3D.__sub = vec3D.__sub
vec3D.__mul = vec3D.__mul
vec3D.__mod = vec3D.__dot
vec3D.__tostring = vec3D.__tos

return vec3D
