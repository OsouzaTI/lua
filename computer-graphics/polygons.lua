local draw_utils = require "draw-utils"
local transformations = require "transformations"
local vec2D = require "vector2D"
local vec3D = require "vector3D"
local matrix = require "matrix"
local colors = require "colors"
local Module = {}
DTangulo = 0

local function change_DTangle()
    if DTangulo < 360 then
        DTangulo = DTangulo + 1
    else DTangulo = 0 end
end

function Module.fill_square(x, y, size, tbRGBA)
    local finalX = x + size
    local finalY = y + size

    for xx = x, finalX, 1 do
        for yy = y, finalY, 1 do
            draw_utils.draw_point(xx, yy, tbRGBA)
        end
    end

end

function Module.square(x, y, size, border, tbRGBA)
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

function Module.triangle(x1, y1, x2, y2, x3, y3, tbRGBA)  
    local HALF_PI = 1.57079632679 -- 90 graus

    local function rotateVector2D(x, y, angle)
        local xx = x * math.cos(angle) - y * math.sin(angle)
        local yy = x * math.sin(angle) + y * math.cos(angle)
        return {x = xx, y = yy}
    end    
    
    local function produtoEscalarVector2D(x1, y1, x2, y2)
        return x1 * x2 + y1 * y2
    end

    local function sign(a)
        if a < 0 then
            return -1
        elseif a > 0 then
            return 1
        else return 0 end
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

function Module.circle(cx, cy, radius, tbRGBA)
    local center = vec2D.new(cx, cy)
    -- A tela vai simetricamente de - size/2... ate +size/2
    -- permitindo assim os quadrantes diagonais

    for x = -HALF_SIZE_SCREEN, HALF_SIZE_SCREEN, 1 do
        for y = -HALF_SIZE_SCREEN, HALF_SIZE_SCREEN, 1 do
            
            -- cria o ponto Q que é representado por 'x' e 'y'
            local Q = vec2D.new(x, y)
            -- calcula a distancia do ponto Q para o centro da circunferencia
            local centerQ = vec2D.distancePoint(Q, center)
            -- verifica se o valor resultante da distancia é menor que o raio(o ponto está interno),
            -- ou se o ponto é igual ao raio(o ponto pertence a circunferencia), caso for maior
            -- o ponto é externo e então ignorado
            if centerQ <= radius then
                -- angulo pode ser qualquer um
                Q = transformations.scale(Q, 1.5, math.cos(angulo))
                Q = transformations.rotate2D(Q, math.rad(angulo))
                Q = transformations.translate(Q, size_screen/2, size_screen/2)
                draw_utils.draw_point(Q.x, Q.y, tbRGBA)
            end

        end
    end
end

function Module.Mcircle(tbRGBA)
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

return Module


