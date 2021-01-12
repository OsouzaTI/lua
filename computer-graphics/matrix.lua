local matrix = {}
local vec3D = require "vector3D"

-- Matrix 2x2

function matrix.mat2x2_mult(table2x2, vector2D)
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

function matrix.tos(M)
    local log = ""
    for i = 0, 2, 1 do
        log = log.."["
        for j = 0, 2, 1 do   
            log = log..tostring(M[i][j])
            if j ~= 2 then log = log..",\t" end
        end
        log = log.."]\n"
    end
    return log
end

function matrix.makeMatrix(mat3x3)
    return setmetatable({
        [0] = { [0] = mat3x3[0], mat3x3[1],  mat3x3[2] },
        [1] = { [0] = mat3x3[3], mat3x3[4],  mat3x3[5] },
        [2] = { [0] = mat3x3[6], mat3x3[7],  mat3x3[8] },
    }, matrix)
end

function matrix.makeScaleMatrix(sx, sy)
    local scale_matrix = {[0]=1/sx, 0, 0, 0, 1/sy, 0, 0, 0, 1}
    return matrix.makeMatrix(scale_matrix)
end

function matrix.makeTranslateMatrix(tx, ty)
    local translate_matrix = {[0]=1, 0, -tx, 0, 1, -ty, 0, 0, 1}
    return matrix.makeMatrix(translate_matrix)
end

function matrix.makeRotateMatrix(a)
    local c, s = math.cos(-a), math.sin(-a)
    local translate_matrix = {[0]= c, -s, 0, s, c, 0, 0, 0, 1}
    return matrix.makeMatrix(translate_matrix)
end

function matrix.new()
    local list = {[0]=0, 0, 0, 0, 0, 0, 0, 0, 0}    
    return matrix.makeMatrix(list)
end


function matrix.mul(A, B)
    local C = matrix.new()

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

function matrix.divideByN(M, n)
    assert(n ~= 0, "Matrix Division by zero")
    local C = matrix.new()
    C[0][0] = M[0][0]/n
    C[0][1] = M[0][1]/n 
    C[0][2] = M[0][2]/n

    C[1][0] = M[1][0]/n 
    C[1][1] = M[1][1]/n
    C[1][2] = M[1][2]/n

    C[2][0] = M[2][0]/n 
    C[2][1] = M[2][1]/n 
    C[2][2] = M[2][2]/n

    return C
end

function matrix.multVec3D(M, u)
    local v = vec3D.new(0, 0, 0)
    v.x = M[0][0] * u.x + M[0][1] * u.y + M[0][2] * u.z;
	v.y = M[1][0] * u.x + M[1][1] * u.y + M[1][2] * u.z;
    v.z = M[2][0] * u.x + M[2][1] * u.y + M[2][2] * u.z;
    return v
end

function matrix.transpose(M)    
    return setmetatable({
        [0] = { [0] = M[0][0], M[1][0], M[2][0] },
        [1] = { [0] = M[0][1], M[1][1], M[2][1] },
        [2] = { [0] = M[0][2], M[1][2], M[2][2] },
    }, matrix)
end

function matrix.inverse(M)
    
    local function det2x2(A)
        return A[0] * A[3] - A[1] * A[2]
    end

    -- Matrizes dos menores complementares
    local M1 = {[0]=M[1][1], M[1][2], M[2][1], M[2][2]}
    local M2 = {[0]=M[1][0], M[1][2], M[2][0], M[2][2]}
    local M3 = {[0]=M[1][0], M[1][1], M[2][0], M[2][1]}
    local M4 = {[0]=M[0][1], M[0][2], M[2][1], M[2][2]}
    local M5 = {[0]=M[0][0], M[0][2], M[2][0], M[2][2]}
    local M6 = {[0]=M[0][0], M[0][1], M[2][0], M[2][1]}
    local M7 = {[0]=M[0][1], M[0][2], M[1][1], M[1][2]}
    local M8 = {[0]=M[0][0], M[0][2], M[1][0], M[1][2]}
    local M9 = {[0]=M[0][0], M[0][1], M[1][0], M[1][1]}

    -- Matriz de cofatores
    --|+    -   +|
    --|-    +   -|
    --|+    -   +|
    local a11 = det2x2(M1)
    local a12 = -det2x2(M2)
    local a13 = det2x2(M3)
    local a21 = -det2x2(M4)
    local a22 = det2x2(M5)
    local a23 = -det2x2(M6)
    local a31 = det2x2(M7)
    local a32 = -det2x2(M8)
    local a33 = det2x2(M9)

    -- determinante de M
    local detM = matrix.det(M)
    -- matriz de cofatores (obj)
    local MC = matrix.makeMatrix({[0]=a11, a12, a13, a21, a22, a23, a31, a32, a33})
    -- transposta da matriz de cofatores
    local tMC = matrix.transpose(MC)

    return matrix.divideByN(tMC, detM)
end

function matrix.applyTransformation(M, N)
    local tM = matrix.transpose(M)
    return tM * N * M 
end

function matrix.det(M)
    -- a11 a12 a13  a11 a12
    -- a21 a22 a23  a21 a22
    -- a31 a32 a33  a31 a32
    return M[0][0] * M[1][1] * M[2][2]
    +  M[1][0] * M[2][1] * M[0][2]
    +  M[2][0] * M[0][1] * M[1][2]
    -  M[2][0] * M[1][1] * M[0][2] 
    -  M[0][0] * M[2][1] * M[1][2]
    -  M[1][0] * M[0][1] * M[2][2]
end

function matrix.centerConic(M)
    local det = matrix.det(M)
    assert(det ~= 0, "Determinant is equal zero")
    -- verificar se for diferente de zeros
    -- cd - be / determinante = P
    -- -bd + ae / determinante =  Q
    local Xc = (M[1][0] * M[1][2] - M[1][1] * M[0][2])/det
    local Yc = (M[1][0] * M[0][2] - M[0][0] * M[1][2])/det

    return vec3D.new(Xc, Yc, 1)
end

matrix.__mul = matrix.mul
matrix.__tostring = matrix.tos
return matrix