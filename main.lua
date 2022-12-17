DUI = require("duckUI")
DUI.setDefaultResolution(1280,720)

LG = love.graphics
COLOR = require("color")
STYLE = require("style")
WINDOW_W,WINDOW_H = LG.getDimensions()

ROOT = require("example_interface")

function love.update(dt)
end

function love.mousepressed( x, y, button)
    ROOT.mousepressed(x,y,button)
end

function love.resize(w,h)
    DUI.resize(w,h)
    ROOT.computeLayout()
end

function love.draw()
    ROOT.draw()
end

love.resize(WINDOW_W,WINDOW_H)
