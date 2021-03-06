require "cdlua"
require "iuplua"
require "iupluacd"

function newWindow(w,h)
    w = w or 300
    h = h or 200
    canvas = iup.canvas{rastersize=w.."x"..h,border="no"}
    dialog = iup.dialog{canvas; title="canvas"}
    
    function canvas:map_cb()
        self.canvas = cd.CreateCanvas(cd.IUP, self)
    end
    
    function canvas:action()
        self.canvas:Activate()
        self.canvas:Clear()
        if self.Draw then
            self:Draw(self.canvas)
        end
    end

    function dialog:close_cb()
        self[1].canvas:Kill()
        self:destroy()
        return iup.IGNORE
    end
    return dialog
end


local dialog = newWindow(w, h)
local canvas = dialog[1]

function canvas:Draw()
    canvas = self.canvas        
    canvas:Rect(0,10,0,10)
end


dialog:show()
iup.MainLoop()