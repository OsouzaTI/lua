local Module = {}
local vec3D = require "vector3D"

-- Matrix 2x2

function Module.mat2x2_mult(table2x2, vector2D)
    local a11 = table2x2[0]
    local a12 = table2x2[1]
    local a21 = table2x2[2]
    local a22 = table2x2[3]

    local x = vector2D.x
    local y = vector2D.y

    return {
        x = a11 * x + a12 * x,
        y = a21 * y + a22 * y 
    }
end

-- Matrix 3x3

function Module.tos(M)
    local log = ""
    for i = 0, 2, 1 do
        log = log.."["
        for j = 0, 2, 1 do   
            log = log..tostring(M[i][j])
            if j ~= 2 then log = log.."," end
        end
        log = log.."]\n"
    end
    return log
end

function Module.makeMatrix(mat3x3)
    return setmetatable({
        [0] = { [0] = mat3x3[0], mat3x3[1],  mat3x3[2] },
        [1] = { [0] = mat3x3[3], mat3x3[4],  mat3x3[5] },
        [2] = { [0] = mat3x3[6], mat3x3[7],  mat3x3[8] },
    }, Module)
end

function Module.makeScaleMatrix(sx, sy)
    local scale_matrix = {[0]=1/sx, 0, 0, 0, 1/sy, 0, 0, 0, 1}
    return Module.makeMatrix(scale_matrix)
end

function Module.makeTranslateMatrix(tx, ty)
    local translate_matrix = {[0]=1, 0, -tx, 0, 1, -ty, 0, 0, 1}
    return Module.makeMatrix(translate_matrix)
end

function Module.makeRotateMatrix(a)
    local c, s = math.cos(-a), math.sin(-a)
    local translate_matrix = {[0]= c, -s, 0, s, c, 0, 0, 0, 1}
    return Module.makeMatrix(translate_matrix)
end

function Module.new()
    local list = {[0]=0, 0, 0, 0, 0, 0, 0, 0, 0}    
    return Module.makeMatrix(list)
end


function Module.mul(A, B)
    local C = Module.new()

    -- Versão LOOP

    -- for i = 0, 2, 1 do
    --     for j = 0, 2, 1 do    
    --         C[i][j] = A[i][0] * B[0][j] + A[i][1] * B[1][j] + A[i][2] * B[2][j];
    --     end
    -- end
       
    -- Versão Sem LOOP

    -- Para i = 0
    C[0][0] = A[0][0] * B[0][0] + A[0][1] * B[1][0] + A[0][2] * B[2][0];
    C[0][1] = A[0][0] * B[0][1] + A[0][1] * B[1][1] + A[0][2] * B[2][1];
    C[0][2] = A[0][0] * B[0][2] + A[0][1] * B[1][2] + A[0][2] * B[2][2];
    -- Para i = 1
    C[1][0] = A[1][0] * B[0][0] + A[1][1] * B[1][0] + A[1][2] * B[2][0];
    C[1][1] = A[1][0] * B[0][1] + A[1][1] * B[1][1] + A[1][2] * B[2][1];
    C[1][2] = A[1][0] * B[0][2] + A[1][1] * B[1][2] + A[1][2] * B[2][2];
    -- Para i = 2
    C[2][0] = A[2][0] * B[0][0] + A[2][1] * B[1][0] + A[2][2] * B[2][0];
    C[2][1] = A[2][0] * B[0][1] + A[2][1] * B[1][1] + A[2][2] * B[2][1];
    C[2][2] = A[2][0] * B[0][2] + A[2][1] * B[1][2] + A[2][2] * B[2][2];

    return C
end

function Module.multVec3D(M, u)
    local v = vec3D.new(0, 0, 0)
    v.x = M[0][0] * u.x + M[0][1] * u.y + M[0][2] * u.z;
	v.y = M[1][0] * u.x + M[1][1] * u.y + M[1][2] * u.z;
    v.z = M[2][0] * u.x + M[2][1] * u.y + M[2][2] * u.z;
    return v
end

function Module.transpose(A)    
    return setmetatable({
        [0] = { [0] = A[0][0], A[1][0], A[2][0] },
        [1] = { [0] = A[0][1], A[1][1], A[2][1] },
        [2] = { [0] = A[0][2], A[1][2], A[2][2] },
    }, Module)
end

Module.__mul = Module.mul
Module.__tostring = Module.tos
return Module