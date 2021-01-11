local matrix = require "matrix"
local vec2D = require "vector2D"
local Module = {}

function Module.reflect(vetor)
    local reflect_matrix = {
        [0] = 1, 0, 0, -1
    }
    -- print(reflect_matrix[3])

    local vector = {x = vetor.x, y = vetor.y}

    return matrix.mat2x2_mult(reflect_matrix, vector)
end

function Module.scale(vetor, sx, sy)
    local scale_matrix = {
        [0] = sx, 0, 0, sy
    }
    local vector = {x = vetor.x, y = vetor.y}
    return matrix.mat2x2_mult(scale_matrix, vector)
end

function Module.translate(vetor, tx, ty)
    return vec2D.new(vetor.x + tx, vetor.y + ty)
end


function Module.rotate2D(vector, angle)
    local xx = vector.x * math.cos(angle) - vector.y * math.sin(angle)
    local yy = vector.x * math.sin(angle) + vector.y * math.cos(angle)
    return vec2D.new(xx, yy)
end    

return Module