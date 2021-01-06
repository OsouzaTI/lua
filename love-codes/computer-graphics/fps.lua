local Module = {}

function Module.get_fps()
    return love.timer.getFPS()
end

return Module