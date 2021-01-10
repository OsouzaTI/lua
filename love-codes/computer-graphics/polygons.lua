local draw_utils = require "draw-utils"
local size_screen = require "conf"

local Module = {}

function Module.fill_square(x, y, size, tbRGBA)
    local finalX = x + size
    local finalY = y + size

    for x = x, finalX, 1 do
        for y = y, finalY, 1 do
            draw_utils.draw_point(x, y, tbRGBA)
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

return Module


