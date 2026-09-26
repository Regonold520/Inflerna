local renderM = {}

renderM.meshes = {}

function renderM:load()
    
end

function renderM:update(dt)
    for k,v in pairs(renderM.meshes) do
        renderM:fixMeshObj(v)
    end
end

function renderM:draw()
    
end

function renderM:createMeshObject(x, y, z, sprite, rect)
    local newObj = {
        x = x,
        y = y,
        z = z,
        dirty = false,
        renderable = util.renderM:genMeshFromImage(util.sprites:getSprite(sprite), rect, sprite),
    }

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

    local subdivideVertex = util.renderM:subdivideMesh(obj.renderable.cornerVertex, 20)

    if obj.renderable.mesh == nil then
        local newMesh = love.graphics.newMesh(subdivideVertex, "strip")

        newMesh:setTexture(obj.renderable.texture)

        obj.renderable.mesh = newMesh
    else
        obj.renderable.mesh:setVertices(subdivideVertex)
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
        texture = util.sprites:getSprite(tex)
    }
end

function renderM:subdivideMesh(vertex, level)
    local tlX, tlY = vertex[1][1], vertex[1][2]
    local trX, trY = vertex[2][1], vertex[2][2]
    local brX, brY = vertex[3][1], vertex[3][2]
    local blX, blY = vertex[4][1], vertex[4][2]

    local subdividedVertex = {}

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
            table.insert(subdividedVertex, newVertex)
        end 
    end
    local reordering = {}

    for row = 0, level - 1 do
        for column = 0, level do
            table.insert(reordering, subdividedVertex[(column * (level + 1) + row + 1)])
            table.insert(reordering, subdividedVertex[(column * (level + 1) + row + 2)])
        end
    end
    return reordering
end


return renderM