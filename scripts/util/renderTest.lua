local renderTest = {}

renderTest.testObj = nil



renderTest.drawables = {}

function lerp(a, b, t)
    return a * (1-t) + b * t
end



function renderTest:load()

    testMesh = util.renderM:createMeshObject(0, 20, 1, "eden_bg", {
        {-1.5, 0, 5},
        { 1.5, 0, 5},
        { 1.5, 0.1, 1},
        {-1.5, 0.1, 1}
    })

    table.insert(renderTest.drawables, testMesh)

    renderTest.testObj = {
        x = 50,
        y = 0,
        z = 5,
        sprite = util.sprites:getSprite("crawler"),
        rot = {
            y = 0
        }
    }

    
    table.insert(renderTest.drawables, renderTest.testObj)
end

local deltaTimer = 0
function renderTest:update(dt)
    deltaTimer = deltaTimer + dt
    
    --cam.z = math.sin(deltaTimer) + 2


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