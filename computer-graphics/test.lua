local vec2D = require "vector2D"
local matrix = require "matrix"

local Module = {}

function Module.conicCentre()
    local M = matrix.makeMatrix({[0]=1, 0, 0, 0, 1, 0, 0, 0, -1})
    local rot = matrix.makeRotateMatrix(math.pi/3)
    local scl = matrix.makeScaleMatrix(2, 3)
    local tr = matrix.makeTranslateMatrix(15, 20)
    M = matrix.applyTransformation(scl, M)
    M = matrix.applyTransformation(rot, M)
    M = matrix.applyTransformation(tr, M)
    print(matrix.centerConic(M))
end

function Module.inverseMatrix()
    local M = matrix.makeMatrix({[0]=-1, -2, 2, 2, 1, 1, 3, 4, 5})
    print(matrix.inverse(M))
end

function Module.divideMatrixByN(n)
    local M = matrix.makeMatrix({[0]=1, 1, 1, 1, 1, 1, 1, 1, 1})
    print(matrix.divideByN(M, n))
end

return Module