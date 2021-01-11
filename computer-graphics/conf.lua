size_screen = 400
HALF_SIZE_SCREEN = size_screen/2
function love.conf(t)
    t.console = true
    t.window.title = "Janela"
    t.window.width  = size_screen
    t.window.height = size_screen
end