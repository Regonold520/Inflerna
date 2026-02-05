local layerV = {}

function layerV:load()
    layerV:registerLayer("limbo",
    {
        r =0.18823529411764706, g = 0.17254901960784313, b = 0.1803921568627451
    }, {
        {sprite=util.sprites:getSprite("limbo_building1"), x=0, y=0}
    }, {
        {sprite=util.sprites:getSprite("limbo_building2"), x=0, y=0}
    }, {
        {sprite=util.sprites:getSprite("limbo_bg_focal"), x=0, y=-10}
    }, {
        {sprite=util.sprites:getSprite("limbo_bg_floor"), x=0, y=0}
    }, {"crawler"})
end

function layerV:update(dt)
    layerV:checkCam()
end

function layerV:draw()
    layerV:drawLayer()
end

function layerV:checkCam()
    local layerChange = true
    if cam.x >= (infernoM.currentLayer.floorSprite:getWidth()*infernoM.currentChunk) + infernoM.currentLayer.floorSprite:getWidth()/2 then
        infernoM.currentChunk = infernoM.currentChunk + 1
        layerChange = true
    elseif cam.x < (infernoM.currentLayer.floorSprite:getWidth()*infernoM.currentChunk) - infernoM.currentLayer.floorSprite:getWidth()/2 then
        infernoM.currentChunk = infernoM.currentChunk - 1
        layerChange = true
    end

    if layerChange then
        local render = 100
        for i=-render,render do
            layerV:loadChunk(infernoM.currentChunk + i)
        end

        for idx, chunk in pairs(infernoM.loadedChunks) do
            if math.abs(idx - infernoM.currentChunk) > render then
                infernoM.loadedChunks[idx] = nil
            end
        end


    end
end

function layerV:loadChunk(idx)

    if infernoM.generatedChunks[idx] == nil then
        layerV:generateChunk(idx)
    else
        infernoM.loadedChunks[idx] = infernoM.generatedChunks[idx]
    end
end

function layerV:drawLayer()
    for a,a1 in pairs(infernoM.currentLayer.focalPoint) do
        love.graphics.draw(a1.sprite,layerV:parallaxX(a1.x, 1.995),a1.y,0,1,1,a1.sprite:getWidth()/2,a1.sprite:getHeight()/2)
    end

    for c,c1 in pairs(infernoM.loadedChunks) do
        love.graphics.draw(infernoM.currentLayer.bgFloor[1].sprite,layerV:parallaxX((c1.chunkWidth*c1.idx), 1.5),80,0,1,1,infernoM.currentLayer.bgFloor[1].sprite:getWidth()/2,infernoM.currentLayer.bgFloor[1].sprite:getHeight()/2)
    end

    local collectedMG = {}
    for c,c1 in pairs(infernoM.loadedChunks) do
        for a,a1 in pairs(c1.midgroundAssets) do
            table.insert(collectedMG, a1)
        end
    end

    table.sort(collectedMG, function(a, b)
        return a.y < b.y
    end)

    for a,a1 in pairs(collectedMG) do
        love.graphics.draw(a1.asset.sprite,layerV:parallaxX(a1.x, math.abs((200-a1.y)/190)),a1.y + 50,0,1,1,a1.asset.sprite:getWidth()/2,a1.asset.sprite:getHeight()/2)
    end

    for c,c1 in pairs(infernoM.loadedChunks) do
        for a,a1 in pairs(c1.foregroundAssets) do
            love.graphics.draw(a1.asset.sprite,a1.x,a1.y,0,1,1,a1.asset.sprite:getWidth()/2,a1.asset.sprite:getHeight()/2)
        end
    end

    for c,c1 in pairs(infernoM.loadedChunks) do
        love.graphics.draw(infernoM.currentLayer.floorSprite,(c1.chunkWidth*c1.idx),125,0,1,1,infernoM.currentLayer.floorSprite:getWidth()/2,infernoM.currentLayer.floorSprite:getHeight()/2)
    end
end

function layerV:parallaxX(worldX, parallaxValue)
    parallaxValue = parallaxValue or 1
    if parallaxValue == 0 then parallaxValue = 0.0001 end

    return worldX - cam.x * (1 - parallaxValue)
end

function layerV:generateChunk(idx)
    local chunkWidth = infernoM.currentLayer.floorSprite:getWidth()
    local pos = (chunkWidth*idx) - chunkWidth/2


    local newChunk = {idx=idx,
        chunkWidth = chunkWidth,
        newColour = {
            r = love.math.random(),
            g = love.math.random(),
            b = love.math.random()
        },
        foregroundAssets = {},
        midgroundAssets = {},
        bgFloor = infernoM.currentLayer.bgFloor
        }

    local lastX = 0
    for i=0, chunkWidth do
        local NOISE = love.math.noise(pos,(i*0.75))
        if NOISE > 0.97 then
            if i - lastX > 110 then
                lastX = i
                table.insert(newChunk.foregroundAssets, {
                    asset = infernoM.currentLayer.foregroundAssets[1],
                    x = pos+i
                })
            end
        end
    end
    local lastX2 = 0
    for i=0, chunkWidth do
        local NOISE = love.math.noise(pos,(i*0.01))
        if NOISE > 0.7 then
            if i - lastX2 > 36 then
                lastX2 = i
                table.insert(newChunk.midgroundAssets, {
                    asset = infernoM.currentLayer.midgroundAssets[1],
                    x = pos+i,
                    y = love.math.random(-110,-70)
                })
            end
        end
    end

    infernoM.generatedChunks[idx] = newChunk
end

function layerV:registerLayer(id, bgColour, foregroundAssets, midgroundAssets, focalPoint, bgFloor, enemyPool)
    local layerEntry = {
        bgColour = bgColour,
        floorSprite = util.sprites:getSprite(id.. "_floor"),
        foregroundAssets = foregroundAssets,
        midgroundAssets = midgroundAssets,
        focalPoint = focalPoint,
        bgFloor = bgFloor,
        enemyPool = enemyPool,
        id = id
    }

    infernoM.layers[id] = layerEntry
end

return layerV