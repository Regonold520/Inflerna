local renderTest = {}

renderTest.testObj = nil
renderTest.testObj2 = nil
renderTest.testObj3 = nil

renderTest.drawables = {}

function renderTest:load()
    renderTest.testObj = {
        x = 50,
        y = 0,
        z = 5,
        sprite = util.sprites:getSprite("crawler"),
        rot = {
            y = 0
        }
    }

    renderTest.testObj2 = {
        x = 50,
        y = 0,
        z = 2,
        sprite = util.sprites:getSprite("harpy")
    }

    renderTest.testObj3 = {
        x = -50,
        y = 0,
        z = 0.5,
        sprite = util.sprites:getSprite("dante")
    }

    table.insert(renderTest.drawables, renderTest.testObj)
    table.insert(renderTest.drawables, renderTest.testObj2)
    table.insert(renderTest.drawables, renderTest.testObj3)
end

local deltaTimer = 0
function renderTest:update(dt)
    deltaTimer = deltaTimer + dt
    cam.x = math.sin(deltaTimer) * 30

    cam.y = math.cos(deltaTimer*2) * 20
    
    renderTest.testObj.z = math.sin(deltaTimer) + 2

    renderTest.testObj.rot.y = renderTest.testObj.rot.y + (dt*2)

    table.sort(renderTest.drawables, function(a, b)
        return a.z > b.z
    end)
end

function renderTest:draw()
   for k,v in pairs(renderTest.drawables) do
        util.sprites:drawObject(v)
   end
end

return renderTest