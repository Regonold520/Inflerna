local renderM = {}

renderM.meshes = {}

function renderM:load()
    
end

local lastQueryValues = {}
local currQueryValues = {}
function renderM:update(dt)
    local runFix = false
    currQueryValues = {cam.x, cam.y, cam.z}
    for k,v in pairs(lastQueryValues) do
        if lastQueryValues[k] ~= currQueryValues[k] then
            runFix = true
        end
    end

    if runFix then
        for k,v in pairs(renderM.meshes) do
            renderM:fixMeshObj(v)
        end
    end

    lastQueryValues = currQueryValues
end

function renderM:draw()
    
end

function renderM:createMeshObject(x, y, z, sprite, rect, divCount)
    divCount = divCount or 10

    local newObj = {
        x = x,
        y = y,
        z = z,
        dirty = false,
        renderable = util.renderM:genMeshFromImage(util.sprites:getSprite(sprite), rect, sprite),
        divisions = divCount
    }

    renderM:subdivideMesh(newObj, divCount)

    renderM:fixMeshObj(newObj)

    table.insert(renderM.meshes, newObj)

    return newObj
end

function renderM:fixMeshObj(obj)
    for k,v in pairs(obj.renderable.cornerVertex) do
        local sX = obj.scaleX or 1
        local sY = obj.scaleY or 1

        local oX = obj.originX or obj.renderable.texture:getWidth()/2
        local oY = obj.originY or obj.renderable.texture:getHeight()/2

        local localX = (obj.renderable.sourceVertex[k][1] - oX) * sX
        local localY = (obj.renderable.sourceVertex[k][2] - oY) * sY


        local nX, nY = util.renderM:Vec3ToScreen(localX + obj.x,
            localY + obj.y,
            obj.renderable.rect[k][3] + obj.z)

        v[1] = nX
        v[2] = nY

    end

    local vertex = obj.renderable.cornerVertex

    local tlX, tlY = vertex[1][1], vertex[1][2]
    local trX, trY = vertex[2][1], vertex[2][2]
    local brX, brY = vertex[3][1], vertex[3][2]
    local blX, blY = vertex[4][1], vertex[4][2]

    for k,v in pairs(obj.renderable.meshVertices) do
        local topX = lerp(tlX, trX, v[3])
        local bottomX = lerp(blX, brX, v[3])

        local topY = lerp(tlY, trY, v[3])
        local bottomY = lerp(blY, brY, v[3])

        local pX = lerp(topX, bottomX, v[4])
        local pY = lerp(topY, bottomY, v[4])

        v[1] = pX
        v[2] = pY
    end

    if obj.renderable.mesh == nil then
        local newMesh = love.graphics.newMesh(obj.renderable.meshVertices, "strip")

        newMesh:setTexture(obj.renderable.texture)

        obj.renderable.mesh = newMesh
    else
        obj.renderable.mesh:setVertices(obj.renderable.meshVertices)
    end
end

function renderM:Vec3ToScreen(x, y, z)
    local screenX, screenY

    local nZ = z - cam.z

    screenX = ((x - cam.x)/nZ)
    screenY = ((y - cam.y)/nZ)

    return screenX, screenY
end

function renderM:genMeshFromImage(img, rect, tex)
    local w = img:getWidth()
    local h = img:getHeight()

    local v = {
        {w * rect[1][1],h * rect[1][2], 0,0},
        {w * rect[2][1],h * rect[2][2], 1,0},
        {w * rect[3][1],h * rect[3][2], 1,1},
        {w * rect[4][1],h * rect[4][2], 0,1}
    }

    return {
        mesh = nil,
        cornerVertex = v,
        sourceVertex = deepCopy(v),
        rect = rect,
        texture = util.sprites:getSprite(tex),
        meshVertices = {}
    }
end

function renderM:subdivideMesh(obj, level)
    local vertex = obj.renderable.cornerVertex

    local tlX, tlY = vertex[1][1], vertex[1][2]
    local trX, trY = vertex[2][1], vertex[2][2]
    local brX, brY = vertex[3][1], vertex[3][2]
    local blX, blY = vertex[4][1], vertex[4][2]

    local meshVertices = {}

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

            table.insert(meshVertices, newVertex)
        end 
    end
    local reordering = {}

    for row = 0, level - 1 do
        for column = 0, level do
            table.insert(reordering, meshVertices[(column * (level + 1) + row + 1)])
            table.insert(reordering, meshVertices[(column * (level + 1) + row + 2)])
        end
    end
    obj.renderable.meshVertices = reordering
end


return renderM