local draw = require "draw-functions"
local colors = require "colors"
local draw_utils = require "draw-utils"
local test = require "test"

function love.load()
end

function love.draw() 		
	test.implicitPolygon(11, 5)	
end