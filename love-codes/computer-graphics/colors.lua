local Module = {}

Module.colors = {
    red   = {r = 255, g = 0, b = 0, a = 255},
    green = {r =  0,  g = 255, b = 0, a = 255},
    blue  = {r =  0, g = 0, b = 255, a = 255},
}

function Module.set_color(tbColor)
    love.graphics.setColor(
        tbColor.r,
        tbColor.g,
        tbColor.b,
        tbColor.a
    )
end

return Module