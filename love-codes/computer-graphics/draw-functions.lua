local colors = require "colors"
--[[
    Author: Ozeias Souza
    Data: 06/01/2021
    Hours:  12:22:20

    Modulo criado para executar testes de algoritmos graficos
    
    * bresenham_line -> Bresenham, J. E,  “Algorithm for computer control of a digital plotter.”

]]--

local Module = {}

function Module.draw_point(x, y, tbRGBA)
    r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(tbRGBA.r, tbRGBA.g, tbRGBA.b, tbRGBA.a)
    love.graphics.points(x, y)
    love.graphics.setColor(r, g, b, a)
end

function Module.draw_fps(x, y, fps)  
    colors.set_color(colors.colors.red)
    love.graphics.print(fps, x, y)
end

function Module.bresenham_line(x0, y0, x1, y1, tbRGBA)
    -- Baseado no código do site :
        -- url: https://www.codingalpha.com/bresenham-line-drawing-algorithm-c-program/
        
    local x, y, dx, dy, temp, pixel
    -- Assume a positive slope
    Module.draw_point(x0, y0, tbRGBA)

    dx = math.abs(x0 - x1)
    dy = math.abs(y0 - y1)
    pixel = 2 * dy - dx

    if x0 > x1 then
        x = x1
        y = y1
        temp = x0
    else
        x = x0
        y = y0
        temp = x1
    end
    
    Module.draw_point(x, y, tbRGBA)

    while x < temp do
        x = x + 1
        if pixel < 0 then
            pixel = pixel + 2 * dy
        else
            y = y + 1
            pixel = pixel + 2 * (dy - dx)
        end
        Module.draw_point(x, y, tbRGBA)
    end

end

return Module