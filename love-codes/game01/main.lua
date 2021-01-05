local screen_width, screen_height
local clear_color_buffer = {r = 0, g = 0 , b = 0}

local function clear_buffer(width, height)
    love.graphics.setColor(
        clear_color_buffer.r,
        clear_color_buffer.g,
        clear_color_buffer.b
    )

    for i = 1, width, 1 do
        for j = 1, height, 1 do
            love.graphics.points(i, j)
        end
    end
end

function love.load()
    screen_width, screen_height = love.graphics.getDimensions()
end

local function draw_circle(mode, x, y, r)
    love.graphics.setColor(0, 0, 255)
    love.graphics.circle(mode, x, y, r)
end

function love.draw()
    clear_buffer(screen_width, screen_height) -- clear the screen with a color
    draw_circle(
        "fill",
        screen_width/2, screen_height/2,
        30
    )
end
