local vec3D = require "vector3D"
local matrix = require "matrix"
local polygons = require "polygons"

local Module = {}

local PI = math.pi

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

function Module.implicityLine()
    local T = polygons.implicitLine(2, 3, 5, 6)
    print(T[1]["a"])
    print(T[1]["b"])
    print(T[1]["c"])
    print(T[1]["s"])
end

function Module.implicitTriangleTeste(x1, y1, x2, y2, x3, y3)
    polygons.implicitTriangle(x1, y1, x2, y2, x3, y3)
end

function Module.implicitPolygon(n, s)
    -- n : lados 
    -- s : não sei lkk
    local edgeList = {}  
    for i = 1, n, 1 do
        local x = math.cos(2*PI*i*s/n)
        local y = math.sin(2*PI*i*s/n)
        local P = vec3D.new(x, y, 1)
        P:mulScalar(100)
        P:sunScalar(HALF_SIZE_SCREEN, HALF_SIZE_SCREEN)
        edgeList[i-1] = {[0] = P.x, P.y}
    end
    polygons.dImplicitpolygon(edgeList)
end

return Module