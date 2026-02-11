local minigameM = {}

minigameM.currentMinigame = nil
minigameM.texts = {}

function minigameM:load()
end

function minigameM:update(dt)
    if minigameM.currentMinigame ~= nil then
        if minigameM.currentMinigame.active then
            minigameM.currentMinigame.runFunc(minigameM, dt)
        end
    end
end

function minigameM:drawUI()
    if minigameM.currentMinigame ~= nil then
        if minigameM.currentMinigame.active then
            minigameM.currentMinigame:drawFunc()
        end
    end

    for t,t1 in pairs(minigameM.texts) do
        t1:draw()
    end
end

function minigameM:startMinigame(id, pot)
    if minigameM.currentMinigame == nil then
        print(id)
        local minigameEntry = {
            pot = pot,
            minigameId = id,
            startFunc = minigameM.minigames[id].startFunc,
            runFunc = minigameM.minigames[id].runFunc,
            drawFunc = minigameM.minigames[id].drawFunc,
            active = false,
            activeData = {}
        }

        minigameM.currentMinigame = minigameEntry

        gardenM.cameraStatic = true

        util.tween:tweenProperty(cam, "zoom", 10.5, 1, "CamZoom", "out")
        util.tween:tweenProperty(cam, "projX", pot.x, 1, "CamMoveX", "out")
        util.tween:tweenProperty(cam, "yAddition", pot.y + 5, 1, "CamMoveY", "out")

        util.tween:tweenProperty(altarM,"vignetteZoomMult" , 0.5, 1, "vignetteZoom", "out")

        util.time:runDeferred(1, function()
            minigameEntry.startFunc()
            minigameEntry.active = true
        end)
    end
end

function minigameM:fertiliserStart()
    minigameM.currentMinigame.activeData = {
        buttons = {},
        buttonsPassed = 0,
        buttonScores = {}
    }

    minigameM:fertiliserTick()
end


function minigameM:fertiliserTick()
    print("hi im erio")
    local newButton = {
        x = love.graphics:getWidth()/2 + love.math.random(-200, 200),
        y = love.graphics:getHeight()/2 + love.math.random(-200, 200),
        sprite = util.sprites:getSprite("fert_button"),
        radius = 30,
        scaleX = 0.7,
        scaleY = 0.7,
        forceClose = false,
        layer = 100,
        isUi = true
    }

    newButton.onClick = function()
        minigameM.currentMinigame.activeData.buttonsPassed = minigameM.currentMinigame.activeData.buttonsPassed + 1
        newButton.forceClose = true
        util.input:markDead(newButton)

        table.insert(minigameM.texts,util.text:createRiseText(newButton.x, newButton.y, "StatusText", "PERFECT", util.sprites.pallets.diligence))
    end

    util.input:addClickable(newButton,"garden")

    table.insert(minigameM.currentMinigame.activeData.buttons, newButton)

end

function minigameM:fertiliserRun(dt)
    local buttons = minigameM.currentMinigame.activeData.buttons
    for i = #buttons, 1, -1 do
        local b1 = buttons[i]
        b1.radius = b1.radius - (dt*30)

        if b1.radius < 1 or b1.forceClose then
            print(minigameM.currentMinigame.activeData.buttonsPassed)
            local rad = b1.radius

            if not b1.forceClose then rad = 0 end

            local strength = 75 + 75 * math.exp(-((rad - 9)^2) / 17)
            table.insert(minigameM.currentMinigame.activeData.buttonScores, strength)

            table.remove(buttons, i)
            if minigameM.currentMinigame.activeData.buttonsPassed < 7 then
                minigameM:fertiliserTick()
            else
                local total = 0
                for s,s1 in pairs(minigameM.currentMinigame.activeData.buttonScores) do
                    total = total + s1
                end
                total = (total / #minigameM.currentMinigame.activeData.buttonScores)

                local rounded = math.floor(total / 5 + 0.5) * 5
                print("The mean score was...", rounded)
            end
        end
    end

end

function minigameM:fertiliserDraw()
    for b,b1 in pairs(minigameM.currentMinigame.activeData.buttons) do
        love.graphics.draw(b1.sprite, b1.x, b1.y, 0, b1.scaleX*cam.zoom, b1.scaleY*cam.zoom, b1.sprite:getWidth()/2, b1.sprite:getHeight()/2)

        local r, g, b = 0.16470588235294117,0.16862745098039217,0.1803921568627451

        if b1.radius > 8 and b1.radius < 10 then r, g, b = 0.596078431372549 , 0.4627450980392157, 0.21568627450980393 end
        print(b1.radius)

        love.graphics.setColor(r, g, b ,1)
        drawPixelCircle(b1.x - (0.5*cam.zoom), b1.y  - (0.5*cam.zoom), b1.radius)
        love.graphics.setColor(1,1,1,1)
    end
end

minigameM.minigames = {
    ["fertiliser"] = {
        startFunc = minigameM.fertiliserStart,
        runFunc = minigameM.fertiliserRun,
        drawFunc = minigameM.fertiliserDraw
    }
}

return minigameM