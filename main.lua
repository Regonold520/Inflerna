flowerM = require("flowerM")

util = {}
util.sprites = require("util/sprites")

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setBackgroundColor(0,0,0)

    util.sprites:load()

    flowerM:load()
    
end

function love.update(dt)

end

function love.draw()
    flowerM:draw()
end