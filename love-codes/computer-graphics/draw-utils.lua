local Module = {}

function Module.draw_point(x, y, tbRGBA)
    love.graphics.setColor(tbRGBA.r, tbRGBA.g, tbRGBA.b, tbRGBA.a)
    love.graphics.points(x, y)
end

return Module