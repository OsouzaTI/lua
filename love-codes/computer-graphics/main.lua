local draw = require "draw-functions"
local colors = require "colors"

function love.load()
  
end


function love.draw() 
  
  draw.Polygons.triangle(50, 50, 100, 50, 75, 150, colors.green)

end
