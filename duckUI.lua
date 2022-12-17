local lib = {}

local LG = love.graphics
lib.default_color = {1,1,1}
lib.default_font = LG.getFont()
lib.window_w,lib.window_h = LG.getDimensions()




--------------- BASECLASS ---------------

function lib.baseClass(options, style)
    local c = {}
    options = options or {}
    style = style or {}
    c.debug_name = options.debug_name or ""
    c.children = options.children or {}
    c.parent = c.parent or {}
    c.padding = style.padding or options.padding or 0
    c.bg_color = style.bg_color or options.color
    c.fillMode = style.fillMode or options.fillMode or "fill"
    c.sizeFactor = style.sizeFactor or options.sizeFactor or 1
    c.margin = style.margin or options.margin or 0

    for i = 1,#c.children do
        c.children[i].parent = c
    end

    function c.draw()

        if c.bg_color ~= nil then
            LG.setColor(c.bg_color)
            LG.rectangle(c.fillMode,c.x,c.y,c.w,c.h)
        end

        for i=1,#c.children do
            c.children[i].draw()
        end
    end

    function c.computeLayout()
    end

    function love.mousepressed( x, y, button)
    end

    return c
end



------------ VERTICAL CONTAINER -------------

function lib.newVerticalContainer(options, style)
    options = options or {}
    style = style or {}
    local c = lib.baseClass(options, style)

    function c.computeLayout(x,y,w,h)
        c.x,c.y,c.w,c.h = x + c.margin,y + c.margin,w - c.margin * 2,h - c.margin * 2
        local cy = c.y
        for i=1,#c.children do
            local ch = c.h * c.children[i].sizeFactor
            c.children[i].computeLayout(c.x + c.padding, cy + c.padding ,c.w - c.padding * 2,math.min(ch, c.h-cy) - c.padding * 2)

            cy = cy + ch
        end
    end

    function c.mousepressed( x, y, button)
        local lastcy = 0
        local cy = c.y
        for i = 1, #c.children do
            
            cy = cy + (c.children[i].sizeFactor * c.h) + c.padding
            if y < cy and y > lastcy then
                c.children[i].mousepressed( x, y, button)
                break
            end
            lastcy = cy
        end
    end

    return c
end



------------ HORIZONTAL CONTAINER -------------

function lib.newHorizontalContainer(options, style)
    local c = lib.baseClass(options, style)

    function c.computeLayout(x,y,w,h)
        c.x,c.y,c.w,c.h = x + c.margin,y + c.margin,w - c.margin * 2,h - c.margin * 2
        local cx = c.x
        for i=1,#c.children do
            local cw = c.w * c.children[i].sizeFactor
            c.children[i].computeLayout(cx + c.padding,y + c.padding,math.min(cw,w-cw) - c.padding * 2,c.h - c.padding * 2)

            cx = cx + cw
        end
    end

    function c.mousepressed( x, y, button)
        local cx = c.x
        for i = 1, #c.children do
            cx = cx + (c.children[i].sizeFactor * c.w) + c.padding
            if x < cx then
                c.children[i].mousepressed( x, y, button)
                break
            end
        end
    end

    return c
end



------------ BUTTON -------------

function lib.newButton(options, style)
    local c = lib.baseClass(options, style)
    style = style or {}
    c.onClick = style.onClick or options.onClick
    c.color = style.color or options.color or {0,0,0}
    c.highlight_color = style.highlight_color or options.highlight_color 
    c.text = options.text or ""
    c.toggleable = style.toggleable or options.toggleable
    c.dependencyTable = style.dependencyTable or options.dependencyTable
    c.dependencyIndex = options.dependencyIndex
    c.alignmet = style.alignmet or options.alignmet or "center"
    c.isOn = false

    if c.dependencyIndex ~= nil then
        c.dependencyTable[c.dependencyIndex] = c
    end

    function c.computeLayout(x,y,w,h)
        c.x,c.y,c.w,c.h = x + c.margin,y + c.margin,w - c.margin * 2,h - c.margin * 2
    end

    function c.mousepressed( x, y, button)
        if c.toggleable then
            c.isOn = not c.isOn

        elseif c.dependencyIndex ~= nil then
            for i = 1, #c.dependencyTable do
                c.dependencyTable[i].isOn = false
            end
            c.isOn = true
            c:onClick()
        elseif c.onClick ~= nil then
            c:onClick() 
        end
    end

    function c.draw()
        if c.highlight_color ~= nil and c.isOn then
            LG.setColor(c.highlight_color)
            LG.rectangle(c.fillMode,c.x,c.y,c.w,c.h)
        elseif c.bg_color ~= nil then
            LG.setColor(c.bg_color)
            LG.rectangle(c.fillMode,c.x,c.y,c.w,c.h)
        end

        
        ---- handle text -----


    end

    return c
end



------------ MAIN CONTAINER -------------

function lib.newMainContainer(options, style)
    local c = lib.baseClass(options, style)

    c.child = options.child or {}

    function c.draw()
        if c.color ~= nil then
            LG.setColor(c.bg_color)
            LG.rectangle(c.fillMode,0,0,lib.window_w,lib.window_h)
        end

        c.child.draw()
    end

    function c.computeLayout()
        c.child.sizeFactor = 1
        c.child.computeLayout(0,0,lib.window_w,lib.window_h)
    end

    function c.mousepressed(x, y, button)
        c.child.mousepressed(x, y, button)
    end

    return c
end



--------- CONFIG FUNCTIONS -----------

function lib.getScale()
    return math.min(lib.window_w / lib.default_res[1], lib.window_h / lib.default_res[2])
end

function lib.resize(w,h)
    lib.window_w = w
    lib.window_h = h
end

function lib.setDefaultColor(color)
    lib.default_color = color
end

function lib.setDefaultResolution(w,h)
    lib.default_res = {w,h}
end

function lib.setDefaultFont(font)
    lib.default_font = font
end



return lib