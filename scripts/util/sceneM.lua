    local sceneM = {}

    sceneM.scenes = {}

    --Enum for the rendering type used in the scene
    -- D2 = 2D, D25 = 2.5D
    sceneM.renderType = {
        D2 = 1,
        D25 = 2
    }

    sceneM.currentScene = nil

    function sceneM:load()

        -- Scene Init

        local gardenScene = sceneM:createScene("garden",{
            gardenM, altarM, flowerM, doorwayM, minigameM, indexM
        }):renderType(sceneM.renderType.D2)

        local infernoScene = sceneM:createScene("inferno",{
            infernoIntermission,layerV, infernoM, playerM, enemyM, battleM
        }):renderType(sceneM.renderType.D2)

        local testScene = sceneM:createScene("test",{
            util.renderTest
        }):renderType(sceneM.renderType.D25)

        infernoScene.onEnter = function()
            infernoM:loadScene()
        end

        gardenScene.onEnter = function()
            cam.x = 0
            cam.projX = 0
        end

        testScene.onEnter = function()
            cam.x = 0
            cam.y = 0
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

        util.time:runDeferred(0.5, function() sceneM:switchScene("test") end)
        
    end

    function sceneM:update(dt)
        if sceneM.scenes[sceneM.activeScene] ~= nil then
            for f,f1 in ipairs(sceneM.scenes[sceneM.activeScene].managers) do
                if f1.update ~= nil then
                    f1:update(dt)
                end
            end
        end
    end 

    function sceneM:draw()
        if sceneM.scenes[sceneM.activeScene] ~= nil then
            if sceneM.currentScene.rendering == sceneM.renderType.D2 then
                cam:attach(sceneM.renderType.D2)
                for f,f1 in ipairs(sceneM.scenes[sceneM.activeScene].managers) do
                    if f1.draw ~= nil then
                        f1:draw()
                    end
                end
                cam:detach(sceneM.renderType.D2)
            elseif sceneM.currentScene.rendering == sceneM.renderType.D25 then
                cam:attach(sceneM.renderType.D25)
                for f,f1 in ipairs(sceneM.scenes[sceneM.activeScene].managers) do
                    if f1.draw ~= nil then
                        f1:draw()
                    end
                end
                cam:detach(sceneM.renderType.D25)
            end

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

        sceneM.currentScene = newScene

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
            managers = managers,
            rendering = sceneM.renderType.D2
        }

        newScene.renderType = function(_, newType)
            newScene.rendering = newType
            return newScene
        end

        sceneM.scenes[id] = newScene

        return newScene
    end

    return sceneM