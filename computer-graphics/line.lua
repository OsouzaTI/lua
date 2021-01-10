local draw_utils = require "draw-utils"

local Module = {}

-- Line Algorithms Rasterization
    
-- * bresenham_line -> Bresenham, J. E,  “Algorithm for computer control of a digital plotter.”

function Module.bresenham_line(x0, y0, x1, y1, tbRGBA)
    -- Baseado no código do site :
        -- url: https://www.codingalpha.com/bresenham-line-drawing-algorithm-c-program/
        
    local x, y, dx, dy, temp, pixel
    -- Assume a positive slope
    draw_utils.draw_point(x0, y0, tbRGBA)

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
    
    draw_utils.draw_point(x, y, tbRGBA)

    while x < temp do
        x = x + 1
        if pixel < 0 then
            pixel = pixel + 2 * dy
        else
            y = y + 1
            pixel = pixel + 2 * (dy - dx)
        end
        draw_utils.draw_point(x, y, tbRGBA)
    end

end


return Module