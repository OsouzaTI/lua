local Module = {}

-- Colors Module
Module = {
    red   = {
        r = 255,
        g =  0,
        b =  0,
        a = 255
    },
    blue  = { 
        r = 0,
        g = 0,
        b = 255,
        a = 255
    },
    green = { 
        r = 0,
        g = 255,
        b = 0,
        a =  255
    },
    random = {
        r = math.random(0, 100),
        g = math.random(0, 150),
        b = math.random(0, 255),
        a = 255,        
    }
}

return Module