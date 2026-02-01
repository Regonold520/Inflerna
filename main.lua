flowerM = require("scripts/garden/flowerM")
altarM = require("scripts/garden/altarM")
gardenM = require("scripts/garden/gardenM")
doorwayM = require("scripts/garden/doorwayM")

sceneM = require("scripts/util/sceneM")

infernoIntermission = require("scripts/inferno/infernoIntermission")
infernoM = require("scripts/inferno/infernoM")
layerV = require("scripts/inferno/layerVisuals")
playerM = require("scripts/inferno/playerM")
enemyM = require("scripts/inferno/enemyM")
battleM = require("scripts/inferno/battleM")

util = {}
util.sprites = require("scripts/util/sprites")
util.tween = require("scripts/util/tween")
util.time = require("scripts/util/time")
util.input = require("scripts/util/input")

cam = {
    x = 0,
    y = -50,
    projX=0,
    zoom = 5,
    rot = 0,
    yAddition = 0
}

cam.zoomModifier = 1

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setBackgroundColor(0,0,0)
    math.randomseed(os.time() + love.timer.getTime() * 1000)

    baseWidth = 1466
    baseHeight = 868

    util.input:load()
    util.sprites:load()
    util.time:load()
    sceneM:load()

    for s,s1 in pairs(sceneM.scenes) do
        for f,f1 in ipairs(s1.managers) do
            if f1.load ~= nil then f1:load() end
        end
    end
end

function love.update(dt)
    util.tween:update(dt)

    util.time:update(dt)
    
    sceneM:update(dt)

    util.input:cleanup(dt)

    if util.input.mousejustpressed then
        util.input.mousejustpressed = false
        util.input:loopClickers()
    end
end


function love.keypressed(key, scancode, isrepeat)
    if sceneM.scenes[sceneM.activeScene] ~= nil then
        for f,f1 in ipairs(sceneM.scenes[sceneM.activeScene].managers) do
            if f1.keypressed ~= nil then
                f1:keypressed(key, scancode, isrepeat)
            end
        end
    end

    if scancode == "i" then
        local new = "garden"
        if sceneM.activeScene == "garden" then new = "inferno" end

        sceneM:switchScene(new)

    end
end


function getScaleFactor()
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()
    
    return math.min(windowWidth / baseWidth, windowHeight / baseHeight)
end

function getWorldMouse()
    return (love.mouse.getX() - love.graphics:getWidth()/2) / (cam.zoom * getScaleFactor()) + cam.x, (love.mouse.getY() - love.graphics:getHeight()/2) / (cam.zoom * getScaleFactor()) + cam.y
end

function love.draw()
    sceneM:draw()
    util.input:draw()
end

function love.mousepressed(x, y, button, istouch)
   if button == 1 then
      util.input.mousejustpressed = true
   end
end


function cam:attach()
    love.graphics.push()

    love.graphics.translate(
        love.graphics.getWidth() / 2,
        love.graphics.getHeight() / 2
    )

    local screenScale = getScaleFactor()
    love.graphics.scale((self.zoom * cam.zoomModifier) * screenScale)

    love.graphics.rotate(math.rad(self.rot))

    love.graphics.translate(-self.x, -self.y)
end

function cam:detach()
    love.graphics.pop()
end

function clamp(min, val, max)
    return math.max(min, math.min(val, max));
end