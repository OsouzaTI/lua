local control_buffer = require "control-buffer"
local draw_functions = require "draw-functions"
local shapes = require "shapes"
local fps = require "fps"
local screen_width, screen_height

local tbColor = {r = 255, g = 0, b = 0, a = 255}
local center = {}

function love.load()
    screen_width, screen_height = love.graphics.getDimensions() 
    --control_buffer.love_clear_buffer()
    center = {
        x = (screen_width / 2), 
        y = (screen_height / 2)
    }
end

local scale = 100
local length, control = 0, 0

function love.draw() 
    shapes.draw_cos(0, center.y, 50)        
    shapes.draw_circle(center.x, center.y, 50)        
    -- Draw FPS
    draw_functions.draw_fps(10, 10, fps.get_fps())    
end
