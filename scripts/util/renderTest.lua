local renderTest = {}

renderTest.testObj = nil
renderTest.testObj2 = nil

function renderTest:load()
    renderTest.testObj = {
        x = 50,
        y = 0,
        z = 5,
        sprite = util.sprites:getSprite("crawler")
    }

    renderTest.testObj2 = {
        x = 50,
        y = 0,
        z = 2,
        sprite = util.sprites:getSprite("harpy")
    }
end

local deltaTimer = 0
function renderTest:update(dt)
    deltaTimer = deltaTimer + dt
    cam.x = math.sin(deltaTimer) * 20
end

function renderTest:draw()
    util.sprites:drawObject(renderTest.testObj)
    util.sprites:drawObject(renderTest.testObj2)
end

return renderTest