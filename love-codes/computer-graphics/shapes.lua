local draw_functions = require "draw-functions"
local colors = require "colors"

local Module = {}

function Module.draw_square(x, y, size)
    for xx = x, x+size, 1 do
        for yy = y, y+size, 1 do
            draw_functions.draw_point(xx, yy, colors.colors.green)            
        end
    end
end

function Module.draw_cos(x, y, scl)
    local two_pi = 4 * math.pi
    for xx = 0, two_pi, 0.01 do
        local _x = x + (xx * scl) 
        local _y = y + scl * (math.cos(xx)) 
        draw_functions.draw_point(_x, _y, colors.colors.green)            
    end
end

function Module.draw_circle(x, y, radius)
    local cRed = colors.colors.red
    local xx = 0
    local yy = radius
    local dd = 3 - (2 * radius)

    -- plot inicial 
    draw_functions.draw_point(x + xx, y + yy, cRed)
    draw_functions.draw_point(x - xx, y + yy, cRed)
    draw_functions.draw_point(x + xx, y - yy, cRed)
    draw_functions.draw_point(x - xx, y - yy, cRed)

    draw_functions.draw_point(x + yy, y + xx, cRed)
    draw_functions.draw_point(x - yy, y + xx, cRed)
    draw_functions.draw_point(x + yy, y - xx, cRed)
    draw_functions.draw_point(x - yy, y - xx, cRed)

    while yy >= xx do
        xx = xx + 1
        if dd > 0 then
            yy = yy - 1
            dd = dd + 4 * (xx - yy) + 10
        else
            dd = dd + 4 * xx + 6
        end
        -- plots subsequentes
        draw_functions.draw_point(x + xx, y + yy, cRed)
        draw_functions.draw_point(x - xx, y + yy, cRed)
        draw_functions.draw_point(x + xx, y - yy, cRed)
        draw_functions.draw_point(x - xx, y - yy, cRed)
    
        draw_functions.draw_point(x + yy, y + xx, cRed)
        draw_functions.draw_point(x - yy, y + xx, cRed)
        draw_functions.draw_point(x + yy, y - xx, cRed)
        draw_functions.draw_point(x - yy, y - xx, cRed)
    end

end

return Module
