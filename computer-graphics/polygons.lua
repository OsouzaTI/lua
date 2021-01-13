local draw_utils = require "draw-utils"
local transformations = require "transformations"
local vec2D = require "vector2D"
local vec3D = require "vector3D"
local matrix = require "matrix"
local colors = require "colors"
local polygons = {}
DTangulo = 0

local function change_DTangle()
    if DTangulo < 360 then
        DTangulo = DTangulo + 1
    else DTangulo = 0 end
end

function polygons.fill_square(x, y, size, tbRGBA)
    local finalX = x + size
    local finalY = y + size

    for xx = x, finalX, 1 do
        for yy = y, finalY, 1 do
            draw_utils.draw_point(xx, yy, tbRGBA)
        end
    end

end

function polygons.square(x, y, size, border, tbRGBA)
    local finalX = x + size
    local finalY = y + size
    local initBorderX = x + border
    local initBorderY = y + border
    
    for xx = x, finalX, 1 do
        for yy = y, finalY, 1 do

            if xx < initBorderX or  yy < initBorderY then
                draw_utils.draw_point(xx, yy, tbRGBA)
            end

            if xx > finalX - border or  yy > finalY - border then
                draw_utils.draw_point(xx, yy, tbRGBA)
            end

        end
    end
end

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

    local function rotateVector2D(x, y, angle)
        local xx = x * math.cos(angle) - y * math.sin(angle)
        local yy = x * math.sin(angle) + y * math.cos(angle)
        return {x = xx, y = yy}
    end    
    
    local function produtoEscalarVector2D(x1, y1, x2, y2)
        return x1 * x2 + y1 * y2
    end

    local u = { x = x2 - x1, y = y2 - y1 }
    local v = { x = x3 - x2, y = y3 - y2 }
    local w = { x = x1 - x3, y = y1 - y3 }

    for xx = 0, size_screen, 1 do
        for yy = 0, size_screen, 1 do

            -- Criando o vetor Q em relação ao primeiro vetor u = (x2-x1, y2-y1)
            local vecQP1 = { x = x1 - xx,  y = y1 - yy }
            -- Criando o vetor Q em relação ao vetor v = (x3-x2, y3-y2)
            local vecQP2 = { x = x2 - xx, y = y2 - yy }
            -- Criando o vetor Q em relação ao vetor w = (x1-x3, y1-y3)
            local vecQP3 = { x = x3 - xx, y = y3 - yy }

            -- Recebe o valor de seu proprio vetor rotacionado 90 graus
            local _u = rotateVector2D(u.x, u.y, HALF_PI)
            local _v = rotateVector2D(v.x, v.y, HALF_PI)
            local _w = rotateVector2D(w.x, w.y, HALF_PI)

            -- Recebe o valor do produto escalar entre os vetores            
            -- acima e os vertices recebidos
            local prod1 = produtoEscalarVector2D(_u.x, _u.y, vecQP1.x , vecQP1.y)
            local prod2 = produtoEscalarVector2D(_v.x, _v.y, vecQP2.x , vecQP2.y)
            local prod3 = produtoEscalarVector2D(_w.x, _w.y, vecQP3.x , vecQP3.y)            
            
            -- caso o sinal do ponto Q em relação a todos os segmentos de
            -- retas sejam iguais, o pixel sera pintado com a cor escolhida
            if sign(prod1) == sign(prod2) and sign(prod2) == sign(prod3) then
                --print("Pinta o pixel")                           
                draw_utils.draw_point(xx, yy, tbRGBA)                
            end
        end
    end
end

function polygons.circle(tbRGBA)
    change_DTangle()
    -- matriz que representa o circulo de raio 1
    local circulo_unitario = matrix.makeMatrix({[0]=1, 0, 0, 0, 1, 0, 0, 0, -1})
    -- Matrizes de Transformações inversas
    local scaleMatrix = matrix.makeScaleMatrix(10+math.cos(DTangulo)*2.5, 8+math.sin(DTangulo)*3.5)
    local translateMatrix = matrix.makeTranslateMatrix(HALF_SIZE_SCREEN, HALF_SIZE_SCREEN)
    local rotateMatrix = matrix.makeRotateMatrix(math.rad(DTangulo))

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

function polygons.implicitPolygon(edgeList)
    local implicitPolygonLines = {}
    local k = 100
    local x = 2
    local e = edgeList
    -- {
    --     [0] =   {[0] = (0.587785 +x) * k, (-0.809017 + x) * k },
    --             {[0] = (-0.951057+x) * k, (0.309017  + x)* k  },
    --             {[0] = (0.951057 +x) * k, ( 0.309017 + x) * k },
    --             {[0] = (-0.587785+x) * k, (-0.809017 + x) * k },
    --             {[0] = (0        +x) * k   , (1 +x) * k}
    -- }

    -- implicitPolygonLines[0] = polygons.implicitLine(e[0][0], e[0][1], e[1][0], e[1][1])
    -- implicitPolygonLines[1] = polygons.implicitLine(e[1][0], e[1][1], e[2][0], e[2][1])    
    -- implicitPolygonLines[2] = polygons.implicitLine(e[2][0], e[2][1], e[3][0], e[3][1])
    -- implicitPolygonLines[3] = polygons.implicitLine(e[3][0], e[3][1], e[4][0], e[4][1])
    -- implicitPolygonLines[4] = polygons.implicitLine(e[4][0], e[4][1], e[0][0], e[0][1])

    for i = 0, #e, 1 do
        if i < #e then
            implicitPolygonLines[i] = polygons.implicitLine(e[i][0], e[i][1], e[i+1][0], e[i+1][1])
        else            
            implicitPolygonLines[i] = polygons.implicitLine(e[i][0], e[i][1], e[0][0], e[0][1])
        end
    end

    for key, value in pairs(implicitPolygonLines) do
        print(value[0]["ymin"], value[0]["ymax"], value[1]["b"])
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


