function love.conf(t)
    
    size_screen = 512
    HALF_SIZE_SCREEN = size_screen/2
    imageData = nil
    image = nil

    t.console = true
    t.window.title = "Janela"
    t.window.width  = size_screen
    t.window.height = size_screen
end