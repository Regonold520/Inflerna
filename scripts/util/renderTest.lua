local renderTest = {}

renderTest.testObj = nil



renderTest.drawables = {}

function lerp(a, b, t)
    return a * (1-t) + b * t
end

function subdivideMesh(mesh, level)
    local tlX, tlY = mesh:getVertexAttribute(1,1)
    local trX, trY = mesh:getVertexAttribute(2,1)
    local brX, brY = mesh:getVertexAttribute(3,1)
    local blX, blY = mesh:getVertexAttribute(4,1)



    for x = 0, level do
        for y = 0, level do
            local u = x / level
            local v = y / level

            local topX = lerp(tlX, trX, u)
            local bottomX = lerp(blX, brX, u)

            local topY = lerp(tlY, trY, u)
            local bottomY = lerp(blY, brY, u)

            local pX = lerp(topX, bottomX, v)
            local pY = lerp(topY, bottomY, v)

            local newVertex = {pX, pY, u, v}
        end 
    end
end

subdivideMesh(0, 3)

function genMeshFromImage(img)
    local v = {
        {-img:getWidth()/2,-img:getHeight()/2, 0,0},
        {img:getWidth()/2,-img:getHeight()/2, 1,0},
        {img:getWidth()/2,img:getHeight()/2, 1,1},
        {-img:getWidth()/2,img:getHeight()/2, 0,1}
    }

    local newMesh = love.graphics.newMesh(v, "fan")

    newMesh:setTexture(util.sprites:getSprite("harpy"))

    return {
        mesh = newMesh,
        cornerVertex = v
    }
end

function Vec3ToScreen(x, y, z)
    local screenX, screenY

    screenX = ((x - cam.x)/z)
    screenY = ((y - cam.y)/z)

    return screenX, screenY
end



function renderTest:load()
    testMesh = {
        x = 0,
        y = 0,

        mesh = genMeshFromImage(util.sprites:getSprite("harpy")),

        cornerVertex = {}
    }

    testMesh.mesh.mesh:setTexture(util.sprites:getSprite("harpy"))
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

   love.graphics.draw(testMesh.mesh.mesh, testMesh.x, testMesh.y, 0, 1, 1)

   love.graphics.setColor(1,0,0)
   love.graphics.rectangle("fill", testMesh.x, testMesh.y, 1, 1)
   love.graphics.setColor(1,1,1)
end

return renderTest