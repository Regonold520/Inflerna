local infernoM = {}

infernoM.currentLayer = nil
infernoM.layers = {}

infernoM.generatedChunks = {}
infernoM.loadedChunks = {}
infernoM.currentChunk = 0

function infernoM:load()
end

function infernoM:update(dt)
end

function infernoM:draw()
    local entities = {playerM.player, playerM.currentParty, enemyM.enemies}
    local collatedDrawers = {}
    for t,t1 in pairs(entities) do
        if t1.sprite == nil then
            for e,e1 in pairs(t1) do
                table.insert(collatedDrawers, e1)
            end
        else
            table.insert(collatedDrawers, t1)
        end
    end

    table.sort(collatedDrawers, function(a, b)
        return a.y < b.y
    end)

    for e,e1 in pairs(collatedDrawers) do
        if e1.data ~= nil then
            flowerM:drawIndividualFlower(e1, {
                face = {x=2}
            })
        end
        if e1.sprite ~= nil then
            util.sprites:drawObject(e1)
        end
    end
end

function infernoM:drawUI()
end

function infernoM:loadScene()
    
    cam.x = 0
    cam.y = -250
    cam.zoom = 3.5
    
    infernoM:loadLayer("limbo") 

    playerM.currentParty = {}

    for i=1,4 do
        table.insert(doorwayM.party, flowerM:generateRandomFlower())
    end

    for f,f1 in pairs(doorwayM.party) do
        local cloned = flowerM:cloneFlower(f1)
        local yP, xP = 0

        if f == 1 then
            xP = 35
            yP = -15
        elseif f == 2 then
            xP = 35
            yP = 15
        elseif f == 3 then
            xP = 70
            yP = -15
        else
            xP = 70
            yP = 15
        end

        cloned.x = -100 + xP
        cloned.y = -250
        util.time:runDeferred(1.1 + (f/4), function() util.tween:tweenProperty(cloned, "y", 90+ yP, 1.5 , f.."MoveY", "in") end)
        table.insert(playerM.currentParty, cloned)
    end

    util.time:runDeferred(1, function() util.tween:tweenProperty(cam, "y", 0, 2, "CamMoveY", "out") end)
    util.time:runDeferred(1.2, function() util.tween:tweenProperty(playerM.player, "y", 90, 1.5, "PlayerMoveY", "in") end)
    util.time:runDeferred(1, function() util.tween:tweenProperty(infernoIntermission.panel, "y", -250, 2, "IntermissionMoveY", "out") end)
    util.time:runDeferred(5, function() enemyM:spawnEnemy("crawler", "limbo", 200) end)
end

function infernoM:layerLoaded()
    for i=-3,3 do
        layerV:loadChunk(i)
    end
end

function infernoM:loadLayer(layerID) 
    infernoM.currentLayer = infernoM.layers[layerID]
    love.graphics.setBackgroundColor(infernoM.currentLayer.bgColour.r,infernoM.currentLayer.bgColour.g,infernoM.currentLayer.bgColour.b)
    infernoM:layerLoaded()
end

return infernoM