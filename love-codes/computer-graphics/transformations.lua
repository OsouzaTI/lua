local matrix = require "matrix"
local Module = {}

function Module.reflect(x, y)
    local reflect_matrix = {
        [0] = 1, 0, 0, -1
    }
    -- print(reflect_matrix[3])

    local vector = {x = x, y = y}

    return matrix.mat2x2_mult(reflect_matrix, vector)
end

function Module.scale(x, y, sx, sy)
    local scale_matrix = {
        [0] = sx, 0, 0, sy
    }
    local vector = {x = x, y = y}
    return matrix.mat2x2_mult(scale_matrix, vector)
end

return Module