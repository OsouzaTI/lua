local vec3 = {}

function vec3.new(x, y, z)
    local instance = setmetatable({x = x, y = y, z = z}, vec3)    

    function instance.mulScalar(self, k)    
        self.x = self.x * k
        self.y = self.y * k
        self.z = self.z * k
    end

    function instance.sunScalar(self, k)    
        self.x = self.x + k
        self.y = self.y + k
        self.z = self.z + k
    end

    return instance
end

-- Vectors Operations

function vec3.add(u, v)    
    return vec3.new(u.x + v.x, u.y + v.y, u.z + v.z)
end

function vec3.sub(u, v)    
    return vec3.new(u.x - v.x, u.y - v.y, u.z - v.z)
end

function vec3.mul(u, v)    
    return vec3.new(u.x * v.x, u.y * v.y, u.z * v.z)
end

function vec3.dot(u, v)    
    return u.x * v.x + u.y * v.y + u.z * v.z
end

function vec3.tos(u)
    return "<"..tostring(u.x)..","..tostring(u.y)..","..tostring(u.z)..">"
end

function vec3.distancePoint(a, b)
    return math.sqrt( (b.x - a.x)^2 + (b.y - a.y)^2 + (b.z - a.z)^2)
end

vec3.__add = vec3.add
vec3.__sub = vec3.add
vec3.__mul = vec3.add
vec3.__mod = vec3.dot
vec3.__tostring = vec3.tos

return vec3