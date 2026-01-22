local sceneM = {}

sceneM.scenes = {}

function sceneM:load()
    local gardenScene = sceneM:createScene("garden",{
        gardenM, flowerM, altarM, doorwayM
    })

    gardenScene.onEnter = function()
        print("garbden")
        cam.x = 0
        cam.projX = 0
    end

    gardenScene.onExit = function()
        altarM.vignetteZoomMult = 4
        cam.zoomModifier = 1
        cam.yAddition = 0
        altarM.slots.primary.y = -love.graphics:getHeight()
        altarM.slots.secondary.y = -love.graphics:getHeight()
        altarM.slots.tertiary.y = -love.graphics:getHeight()

        gardenM.cameraStatic = false
        altarM.altarGuiEnabled = false

        cam.roomPos = 0
    end

    sceneM:switchScene("garden")
end

function sceneM:update(dt)
    if sceneM.scenes[sceneM.activeScene] ~= nil then
        for f,f1 in ipairs(sceneM.scenes[sceneM.activeScene].managers) do
            f1:update(dt)
        end
    end
end

function sceneM:draw()
    if sceneM.scenes[sceneM.activeScene] ~= nil then
        cam:attach()
        for f,f1 in ipairs(sceneM.scenes[sceneM.activeScene].managers) do
            if f1.draw ~= nil then
                f1:draw()
            end
        end
        cam:detach()

        for f,f1 in ipairs(sceneM.scenes[sceneM.activeScene].managers) do
            if f1.drawUI ~= nil then
                f1:drawUI()
            end
        end
    end
end

function sceneM:switchScene(targetScene)
    local oldScene = sceneM.scenes[sceneM.activeScene]
    local newScene = sceneM.scenes[targetScene]

    if oldScene and oldScene.onExit then
        oldScene:onExit()
    end

    sceneM.activeScene = targetScene

    if newScene and newScene.onEnter then
        newScene:onEnter()
    end

    util.tween:clearSceneTweens(targetScene)
end

function sceneM:createScene(id, managers)
    local newScene = {
        isActive = false,
        inputChannel = id,
        inputObjects = {},
        managers = managers
    }

    sceneM.scenes[id] = newScene

    return newScene
end

return sceneM