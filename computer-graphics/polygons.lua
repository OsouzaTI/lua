
local draw_utils = require "draw-utils"
local transformations = require "transformations"
local vec2D = require "vector2D"
local vec3D = require "vector3D"
local matrix = require "matrix"
local colors = require "colors"

-- Author: Ozéias Souza
-- Data: 13/01/2021
-- Hours:  11:55:28

local polygons = {}

function polygons.sign(a)
    if a < 0 then
        return -1
    elseif a > 0 then
        return 1
    else return 0 end
end

function polygons.triangle(x1, y1, x2, y2, x3, y3, tbRGBA)  
    local sign = polygons.sign

    local HALF_PI = 1.57079632679 -- 90 graus
    
    local u = vec2D.new(x2 - x1, y2 - y1)
    local v = vec2D.new(x3 - x2, y3 - y2)
    local w = vec2D.new(x1 - x3, y1 - y3)

    for xx = 0, size_screen, 1 do
        for yy = 0, size_screen, 1 do

            -- Criando o vetor Q em relação ao primeiro vetor u = (x2-x1, y2-y1)
            local vecQP1 = vec2D.new(x1 - xx, y1 - yy)
            -- Criando o vetor Q em relação ao vetor v = (x3-x2, y3-y2)
            local vecQP2 = vec2D.new(x2 - xx, y2 - yy)
            -- Criando o vetor Q em relação ao vetor w = (x1-x3, y1-y3)
            local vecQP3 = vec2D.new(x3 - xx, y3 - yy)

            -- Recebe o valor de seu proprio vetor rotacionado 90 graus
            local _u = u:rotate(HALF_PI) -- rotateVector2D(u.x, u.y, HALF_PI)
            local _v = v:rotate(HALF_PI)    -- rotateVector2D(v.x, v.y, HALF_PI)
            local _w = w:rotate(HALF_PI) -- rotateVector2D(w.x, w.y, HALF_PI)

            -- Recebe o valor do produto escalar entre os vetores            
            -- acima e os vertices recebidos
            local prod1 = _u % vecQP1 -- % : produto escalar da tabela vec2D
            local prod2 = _v % vecQP2
            local prod3 = _w % vecQP3          
            
            -- caso o sinal do ponto Q em relação a todos os segmentos de
            -- retas sejam iguais, o pixel sera pintado com a cor escolhida
            
            if sign(prod1) == sign(prod2) and sign(prod2) == sign(prod3) then                                         
                draw_utils.draw_point(xx, yy, tbRGBA)                
            end
        end
    end
end
local num = 0
function polygons.circle(cx, cy, radius, tbRGBA)
    num = num + 10
    -- matriz que representa o circulo de raio 1
    local circulo_unitario = matrix.makeMatrix({[0]=1, 0, 0, 0, 1, 0, 0, 0, -1})
    -- Matrizes de Transformações inversas
    local scaleMatrix = matrix.makeInverseScaleMatrix(radius-4, radius-2)
    local translateMatrix = matrix.makeInverseTranslateMatrix(cx, cy)
    local rotateMatrix = matrix.makeInverseRotateMatrix(math.rad(num))

    for xx = 0, size_screen, 1 do
        for yy = 0, size_screen, 1 do
    
            -- Ponto P qualquer
            local P = vec3D.new(xx, yy, 1)
            
            local T = {}
            -- Escalonando
            T = matrix.applyTransformation(scaleMatrix, circulo_unitario)
            -- Rotação
            T =  matrix.applyTransformation(rotateMatrix, T)
            -- Translação 
            T =  matrix.applyTransformation(translateMatrix, T)

            local R = matrix.multVec3D(T, P)     
            if R.x^2 + R.y^2 < 1 then
                --print(R)
                draw_utils.draw_point(xx, yy, tbRGBA)
            end

        end
    end

end

--[[
    Implementação dos polígonos utilizando a linha implicita
]] --

function polygons.implicitLine(x1, y1, x2, y2)
    local a = y2 - y1
    local b = x1 - x2
    local c = -(a * x1 + b * y1)
    local s = polygons.sign(a)
    
    local function sortY(t)
        local _t = {
            ymin = nil,
            ymax = nil
        }
        if t[0] > t[1] then
            local temp = t[0]
            _t["ymin"] = t[1]
            _t["ymax"] = temp
        else 
            _t["ymin"] = t[0]
            _t["ymax"] = t[1]            
        end
        return _t
    end

    return {
        [0] = sortY({[0]= y1, y2}),
        {
            ["a"] = s * a,
            ["b"] = s * b,
            ["c"] = s * c,
            ["s"] = s
        }
    }
end

function polygons.implicitLinewIndingNumber(l, x, y)
    local condicion = y > l[0]["ymin"] and y <= l[0]["ymax"] and (l[1]["a"] * x + l[1]["b"] * y + l[1]["c"]) < 0
    if condicion then    
        return l[1]["s"]
    end
    return 0
end

function polygons.implicitTriangle(x1, y1, x2, y2, x3, y3)
    
    local implicitLineAB = polygons.implicitLine(x1, y1, x2, y2)
    local implicitLineBC = polygons.implicitLine(x2, y2, x3, y3)
    local implicitLineCA = polygons.implicitLine(x3, y3, x1, y1)

    return {
        [0] = implicitLineAB,
        implicitLineBC,
        implicitLineCA
    }

end

function polygons.implicitTriangleWindingNumber(implicitTriangle, x, y)
    local sum = 0
    for i = 0, 2, 1 do
        sum = sum + polygons.implicitLinewIndingNumber(implicitTriangle[i], x, y)        
    end
    return sum
end



function polygons.implicitPolygon(edgeList)
    local implicitPolygonLines = {}
    local e = edgeList
        
        for i = 0, #e, 1 do
            if i < #e then
                implicitPolygonLines[i] = polygons.implicitLine(e[i][0], e[i][1], e[i+1][0], e[i+1][1])
            else            
                implicitPolygonLines[i] = polygons.implicitLine(e[i][0], e[i][1], e[0][0], e[0][1])
            end
        end
          
        return implicitPolygonLines
    end
    
    function polygons.implicitPolygonWindingNumber(implicitPolygon, x, y)
        local sum = 0
        for _, value in pairs(implicitPolygon) do
            sum = sum + polygons.implicitLinewIndingNumber(value, x, y) 
        end
        return sum
    end    
    
    function polygons.dImplicitLine(x1, y1, x2, y2, x3, y3)
        local implicitLine = polygons.implicitLine(x1, y1, x2, y2)
        for xx = 0, size_screen, 1 do
            for yy = 0, size_screen, 1 do
                local sumImplicitLine = polygons.implicitLinewIndingNumber(implicitLine, xx, yy)
                if sumImplicitLine ~= 0 then
                    draw_utils.draw_point(xx, yy, colors.green)
                end
            end
        end
    end
    
    function polygons.dImplicitTriangle(x1, y1, x2, y2, x3, y3)
        local implicitTriangleLines = polygons.implicitTriangle(x1, y1, x2, y2, x3, y3)
        for xx = 0, size_screen, 1 do
            for yy = 0, size_screen, 1 do
                local sumImplicitTriangleWindingNumber = polygons.implicitTriangleWindingNumber(implicitTriangleLines, xx, yy)            
                if sumImplicitTriangleWindingNumber ~= 0 then
                    draw_utils.draw_point(xx, yy, colors.green)
                end
            end
        end
    end
    
    function polygons.dImplicitpolygon(edgeList)
        local implicitPolygonLines = polygons.implicitPolygon(edgeList)
        
        for xx = 0, size_screen, 1 do
            for yy = 0, size_screen, 1 do
                local P = vec3D.new(xx, yy, 1)                  
                
                local sumImplicitPolygonWindingNumber = polygons.implicitPolygonWindingNumber(implicitPolygonLines, P.x, P.y)            
                if sumImplicitPolygonWindingNumber ~= 0 then
                    draw_utils.draw_point(P.x, P.y, colors.green)                
                end
            end
        end
    end
    
return polygons


