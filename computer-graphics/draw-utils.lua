local Module = {}

function Module.draw_point(x, y, tbRGBA)
    love.graphics.setColor(tbRGBA.r, tbRGBA.g, tbRGBA.b, tbRGBA.a)
    love.graphics.points(x, y)
end

function Module.clear_buffer(tbRGBA)
    love.graphics.clear(tbRGBA.r, tbRGBA.g, tbRGBA.b, tbRGBA.a)
end

function Module.fps(x, y, tbRGBA)
    love.graphics.setColor(tbRGBA.r, tbRGBA.g, tbRGBA.b, tbRGBA.a)
    love.graphics.print(love.timer.getFPS(), x, y)
end

return Module