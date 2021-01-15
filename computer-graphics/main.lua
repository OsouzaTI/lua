local draw = require "draw-functions"
local colors = require "colors"
local draw_utils = require "draw-utils"
local test = require "test"
local polygons = require "polygons"

local function pixelFunction(x, y, r, g, b, a)
    -- template for defining your own pixel mapping function
    -- perform computations giving the new values for r, g, b and a
	-- ...	

	

    return r, g, b, a
end

function love.update()
	image = love.graphics.newImage(imageData)	
end

function love.load()
	imageData = love.image.newImageData(size_screen, size_screen)
	imageData:mapPixel(pixelFunction)
end

function love.draw() 
	love.graphics.draw(image)
end