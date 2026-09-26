local layerV = {}

function layerV:load()
    layerV:registerLayer("limbo",
    {
        r =0.18823529411764706, g = 0.17254901960784313, b = 0.1803921568627451
    }, {
        {sprite=util.sprites:getSprite("limbo_building1"), x=0, y=0, z= 4}
    }, {
        {sprite=util.sprites:getSprite("limbo_building2"), x=0, y=0, z= 3}
    }, {
        {sprite=util.sprites:getSprite("limbo_bg_focal"), x=0, y=0, z= 2.1, projectZ=100}
    }, {
        {sprite=util.sprites:getSprite("limbo_bg_floor"), x=0, y=0, z= 2}
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
    local collected = {}

    table.insert(collected, infernoM.currentLayer.focalPoint[1])
    
    for k,v in pairs(infernoM.loadedChunks) do
        table.insert(collected, v.chunkBGFloor)
    end

    for _, assets in pairs(infernoM.loadedChunks) do
        for _, asset in ipairs(assets.midgroundAssets) do
            table.insert(collected, asset)
        end

        for _, asset in ipairs(assets.foregroundAssets) do
            table.insert(collected, asset)
        end
    end

    table.sort(collected, function(a, b)
        return a.z > b.z
    end)

    for k,v in pairs(collected) do
        util.sprites:drawObject(v)
    end


    for c,c1 in pairs(infernoM.loadedChunks) do
        util.sprites:drawObject(c1.chunkFloor)
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
        chunkBGFloor = {
            x = chunkWidth*idx,
            y = 100,
            z = 2,
            sprite = util.sprites:getSprite("limbo_bg_floor")
        },
        chunkFloor = util.renderM:createMeshObject(chunkWidth*idx, 145,0.5, "limbo_floor", {
            {-0.5, 0, 1},
            { 0.5, 0, 1},
            { 0.5, 0, 0},
            {-0.5, 0, 0}
        })

        
        }

    local lastX = 0
    for i=0, chunkWidth do
        local NOISE = love.math.noise(pos,(i*0.75))
        if NOISE > 0.97 then
            if i - lastX > 110 then
                lastX = i
                table.insert(newChunk.foregroundAssets, {
                    sprite = infernoM.currentLayer.foregroundAssets[1].sprite,
                    asset = infernoM.currentLayer.foregroundAssets[1],
                    x = pos+i,
                    y = 0,
                    z = 1
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
                    sprite = infernoM.currentLayer.midgroundAssets[1].sprite,
                    asset = infernoM.currentLayer.midgroundAssets[1],
                    x = pos+i,
                    y = -50,
                    z = 1.5 + (love.math.random(-2, 1)/5)
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