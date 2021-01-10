local draw = require "draw-functions"
local colors = require "colors"

function love.load()
  
end


function love.draw() 
  
  draw.Polygons.triangle(0, 0, 100, 100, 200, 0, colors.green)

end
