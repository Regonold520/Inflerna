local renderTest = {}

renderTest.testObj = nil



renderTest.drawables = {}

function lerp(a, b, t)
    return a * (1-t) + b * t
end



function renderTest:load()

    testMesh = util.renderM:createMeshObject(0, 50, 1, "limbo_floor", {
        {-10.5, 0, 5},
        { 10.5, 0, 5},
        { 10.5, 0.1, 0},
        {-10.5, 0.1, 0}
    })

    table.insert(renderTest.drawables, testMesh)

    renderTest.testObj = {
        x = 0,
        y = 200,
        z = 3,
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