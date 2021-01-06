local colors = require "colors"

local Module = {}

function Module.clear_buffer(width, height)
    local clear_color_buffer = colors.colors.blue
    love.graphics.setColor(
        clear_color_buffer.r,
        clear_color_buffer.g,
        clear_color_buffer.b,
        clear_color_buffer.a
    )

    for i = 0, width, 1 do
        for j = 0, height, 1 do
            love.graphics.points(i, j)
        end
    end
end

function Module.love_clear_buffer()
    love.graphics.setBackgroundColor(
        colors.colors.blue.r,
        colors.colors.blue.g,
        colors.colors.blue.b,
        colors.colors.blue.a
    )
end

return Module