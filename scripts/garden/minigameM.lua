local minigameM = {}

minigameM.currentMinigame = nil
minigameM.texts = {}

function minigameM:load()
    util.sprites:registerPallet({
        "#ff6b44",
        "#fb3c26",
        "#ee2318",
        "#dc121c",
        "#6a080d"
    }, "red")

    util.sprites:registerPallet({
        "#55a7d3",
        "#4990c6",
        "#3978a8",
        "#2e6b9a",
        "#173c58"
    }, "blue")

    minigameM.minigames = {
        ["fertiliser"] = {
            startFunc = minigameM.fertiliserStart,
            runFunc = minigameM.fertiliserRun,
            drawFunc = minigameM.fertiliserDraw,
            modifierType = "attack"
        },
        ["water"] = {
            preStartFunc = minigameM.waterPreStart,
            startFunc = minigameM.waterStart,
            runFunc = minigameM.waterRun,
            drawFunc = minigameM.waterDraw,
            modifierType = "defence"
        }
    }
end

local deltaTimer = 0
function minigameM:update(dt)
    deltaTimer = deltaTimer + dt
    if minigameM.currentMinigame ~= nil then
        if minigameM.currentMinigame.active then
            minigameM.currentMinigame.runFunc(minigameM, dt)
        end
    end
end

function minigameM:drawUI()
    if minigameM.currentMinigame ~= nil then
        minigameM.currentMinigame:drawFunc()
    end

    for t,t1 in pairs(minigameM.texts) do
        t1:draw()
    end

    if minigameM.currentMinigame ~= nil then
        if minigameM.currentMinigame.endScreen ~= nil then
            minigameM.currentMinigame.endScreen.endText.x = minigameM.currentMinigame.endScreen.x - 180
            minigameM.currentMinigame.endScreen.endText.y = minigameM.currentMinigame.endScreen.y - 10

            minigameM.currentMinigame.endScreen.endText.scaleX, minigameM.currentMinigame.endScreen.endText.scaleY  = 3,3

            minigameM.currentMinigame.endScreen.modifierTypeText.x = minigameM.currentMinigame.endScreen.x - 240
            minigameM.currentMinigame.endScreen.modifierTypeText.y = minigameM.currentMinigame.endScreen.y - 35

            minigameM.currentMinigame.endScreen.modifierTypeText.scaleX, minigameM.currentMinigame.endScreen.modifierTypeText.scaleY  = 4,4
            minigameM.currentMinigame.endScreen.modifierTypeText.rot = math.rad(-6)
 
            local o = minigameM.currentMinigame.endScreen
            
            love.graphics.draw(o.bgSprite, o.x, o.y, 0, cam.zoom, cam.zoom, o.bgSprite:getWidth()/2, o.bgSprite:getHeight()/2)

            minigameM.currentMinigame.endScreen.bloomText.x = minigameM.currentMinigame.endScreen.x - 200
            minigameM.currentMinigame.endScreen.bloomText.y = minigameM.currentMinigame.endScreen.y + 120 + math.sin(deltaTimer)*6

            minigameM.currentMinigame.endScreen.bloomText.scaleX, minigameM.currentMinigame.endScreen.bloomText.scaleY  = 3,3
            minigameM.currentMinigame.endScreen.bloomText.rot = math.rad(-4)
            
            minigameM.currentMinigame.endScreen.endText:draw()
            minigameM.currentMinigame.endScreen.modifierTypeText:draw()
            minigameM.currentMinigame.endScreen.bloomText:draw()

            minigameM.currentMinigame.endScreen.bloomButton.x = minigameM.currentMinigame.endScreen.x + 50
            minigameM.currentMinigame.endScreen.bloomButton.y = minigameM.currentMinigame.endScreen.y + 180

            minigameM.currentMinigame.endScreen.bloomButton.rot = math.rad(math.sin(deltaTimer*2)*5)

            love.graphics.draw(o.bloomButton.sprite, o.bloomButton.x, o.bloomButton.y, o.bloomButton.rot,o.bloomButton.scale * cam.zoom,o.bloomButton.scale * cam.zoom, o.bloomButton.sprite:getWidth()/2, o.bloomButton.sprite:getHeight()/2)
            

            if o.rank.rankActive then
                love.graphics.draw(o.rankSprite, o.x + o.rank.x, o.y + o.rank.y, math.rad(o.rank.rot), o.rank.scale*cam.zoom, o.rank.scale*cam.zoom, o.rankSprite:getWidth()/2, o.rankSprite:getHeight()/2)
            end
            
        end
    end
end

function minigameM:startMinigame(id, pot)
    if minigameM.currentMinigame == nil then
        local minigameEntry = {
            pot = pot,
            minigameId = id,
            preStartFunc = minigameM.minigames[id].preStartFunc,
            startFunc = minigameM.minigames[id].startFunc,
            runFunc = minigameM.minigames[id].runFunc,
            drawFunc = minigameM.minigames[id].drawFunc,
            active = false,
            activeData = {},
            endScreen = nil,
            modifierType = minigameM.minigames[id].modifierType
        }

        minigameM.currentMinigame = minigameEntry

        gardenM.cameraStatic = true

        util.tween:tweenProperty(cam, "zoom", 10.5, 1, "CamZoom", "out")
        util.tween:tweenProperty(cam, "projX", pot.x, 1, "camTweenX", "out")
        util.tween:tweenProperty(cam, "yAddition", pot.y + 5, 1, "CamMoveY", "out")

        util.tween:tweenProperty(altarM,"vignetteZoomMult" , 0.5, 1, "vignetteZoom", "out")

        if minigameEntry.preStartFunc ~= nil then
            minigameEntry.preStartFunc()
        end


        util.time:runDeferred(1, function()
            minigameEntry.startFunc()
            minigameEntry.active = true
        end)
    end
end

function minigameM:endMinigame()
    minigameM.currentMinigame = nil

    util.tween:tweenProperty(cam, "zoom", 5, 1, "CamZoom", "out")
    util.tween:tweenProperty(cam, "projX", 0, 1, "CamMoveX", "out")
    util.tween:tweenProperty(cam, "yAddition", 0, 1, "CamMoveY", "out")

    util.tween:tweenProperty(altarM,"vignetteZoomMult" , 4, 1, "vignetteZoom", "out")

    util.time:runDeferred(1, function()
        gardenM.cameraStatic = false
    end)
end

function minigameM:createEndScreen(score)
    local evalRank = nil

    if score >= 75 and score < 90 then
        evalRank = "F"
    elseif score >= 90 and score < 105 then
        evalRank = "C"
    elseif score >= 105 and score < 120 then
        evalRank = "B"
    elseif score >= 120  and score < 135 then
        evalRank = "A"
    elseif score >= 135 then
        evalRank = "P"
    end

    print("input score = ",score, "output rank = ", evalRank)

    local newScreen = {
        x=-love.graphics:getWidth(),
        y=love.graphics:getHeight()/2,
        bgSprite = util.sprites:getSprite("minigame_status_bg"),
        rankSprite = util.sprites:getSprite("minigame_rank_".. evalRank),
        rank = {
            x = 160,
            y = -450,
            rot = 200,
            scale = 10,
            rankActive = false
        },
        bloomButton = {
            x = 0,
            y = 0,
            rot = 0,
            scale = 0.7,
            scaleX = 0.7,
            scaleY = 0.7,
            sprite = util.sprites:palletSwap(util.sprites:getSprite("flower_bloom_button"), util.sprites.pallets.chastity, util.sprites.pallets[minigameM.currentMinigame.pot.flower.data.chosenColour])
        }
    }

    util.input:addClickable(newScreen.bloomButton,"garden", true)

    newScreen.bloomButton.onClick = function()
        if not minigameM.currentMinigame then
            return
        end
        minigameM.currentMinigame.pot.flower.growthStage = "bulb"
        minigameM.currentMinigame.pot.flower.growth = 0

        util.input:markDead(newScreen.bloomButton)
        minigameM:endMinigame()
    end



    local newPal = nil
    if score < 100 then
        newPal = util.sprites.pallets.red
    elseif score == 100 then
        newPal = util.sprites.pallets.chastity
    elseif score == 150 then
        newPal = util.sprites.pallets.patience
    else
        newPal = util.sprites.pallets.kindness
    end

    newScreen.endText = util.text:createText("EndText", "Modifier: ".. score.. "%", newPal,0, true)
    newScreen.modifierTypeText = util.text:createText("modifierTypeText",lang.taskModifierTypes[minigameM.currentMinigame.modifierType].text , util.sprites.pallets.blue,0, true)
    newScreen.bloomText = util.text:createText("modifierBloomText", "Flower ready for bloom!", util.sprites.pallets[minigameM.currentMinigame.pot.flower.data.chosenColour],150, true, true)

    minigameM.currentMinigame.endScreen = newScreen

    util.tween:tweenProperty(newScreen, "x", love.graphics:getWidth()/5, 0.3, "minigameEndBg", "out")

    util.time:runDeferred(0.28, function()
        newScreen.rank.rankActive = true
        util.tween:tweenProperty(newScreen.rank, "x", -120, 0.19, "minigameRankX", "out")
        util.tween:tweenProperty(newScreen.rank, "y", -200, 0.2, "minigameRankY", "out")
        util.tween:tweenProperty(newScreen.rank, "scale", 0.7, 0.2, "minigameRankScale", "out")
        util.tween:tweenProperty(newScreen.rank, "rot", -10, 0.22, "minigameRankRot", "out")



        
    end)

    util.time:runDeferred(0.48, function() util.tween:tweenProperty(newScreen.rank, "scale", 1, 0.1, "minigameRankScale", "out") end)
end

-- Fertiliser --

function minigameM:fertiliserStart()
    if not minigameM.currentMinigame then
        return
    end

    minigameM.currentMinigame.activeData = {
        buttons = {},
        buttonsPassed = 0,
        buttonScores = {}
    }

    minigameM:fertiliserTick()
end

function minigameM:fertiliserRun(dt)
    local buttons = minigameM.currentMinigame.activeData.buttons
    for i = #buttons, 1, -1 do
        local b1 = buttons[i]
        b1.radius = b1.radius - (dt*45)

        if b1.radius < 1 or b1.forceClose then
            local rad = b1.radius

            if not b1.forceClose then rad = 0 end

            local strength = 75 + 75 * math.exp(-((rad - 8)^2) / 5)

            table.insert(minigameM.currentMinigame.activeData.buttonScores, strength)

            local err = math.abs(rad - 8)
            local targetTxt = nil
            local targetPallet = nil

            if err <= 0.4 then
                targetTxt = lang.taskPerformance.perfect.text
                targetPallet = util.sprites.pallets.diligence
            elseif err <= 1.5 then
                targetTxt = lang.taskPerformance.great.text
                targetPallet = util.sprites.pallets.kindness
            elseif err <= 3.5 then
                targetTxt = lang.taskPerformance.good.text
                targetPallet = util.sprites.pallets.chastity
            else
                targetTxt = lang.taskPerformance.bad.text
                targetPallet = util.sprites.pallets.charity
            end

            minigameM.currentMinigame.activeData.buttonsPassed = minigameM.currentMinigame.activeData.buttonsPassed + 1
            util.input:markDead(b1)

            if b1.forceClose == false then
                targetTxt = lang.taskPerformance.miss.text
                targetPallet = util.sprites.pallets.red
            end

            table.insert(minigameM.texts,util.text:createRiseText(b1.x, b1.y - 50, "StatusText", targetTxt, targetPallet))

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
                --minigameM:endMinigame()
                minigameM:createEndScreen(rounded)
            end
        end
    end

end

function minigameM:fertiliserDraw()
    if minigameM.currentMinigame.active then
        for b,b1 in pairs(minigameM.currentMinigame.activeData.buttons) do
            love.graphics.draw(b1.sprite, b1.x, b1.y, 0, b1.scaleX*cam.zoom, b1.scaleY*cam.zoom, b1.sprite:getWidth()/2, b1.sprite:getHeight()/2)

            local r, g, b = 0.16470588235294117,0.16862745098039217,0.1803921568627451

            if b1.radius > 8 and b1.radius < 10 then r, g, b = 0.596078431372549 , 0.4627450980392157, 0.21568627450980393 end

            love.graphics.setColor(r, g, b ,1)
            drawPixelCircle(b1.x - (0.5*cam.zoom), b1.y  - (0.5*cam.zoom), b1.radius)
            love.graphics.setColor(1,1,1,1)
        end
    end
end

function minigameM:fertiliserTick()
    local newButton = {
        x = love.graphics:getWidth()/2 + love.math.random(-200, 200),
        y = love.graphics:getHeight()/2 + love.math.random(-200, 200),
        sprite = util.sprites:palletSwap(util.sprites:getSprite("fert_button"), util.sprites.pallets.chastity, util.sprites.pallets[minigameM.currentMinigame.pot.flower.data.chosenColour]),
        radius = 30,
        scaleX = 0.7,
        scaleY = 0.7,
        forceClose = false,
        layer = 100,
        isUi = true
    }

    newButton.onClick = function()
        if minigameM.currentMinigame ~= nil then
            cam.shake(love.math.random(-200,200))
            newButton.forceClose = true
        end
    end

    util.input:addClickable(newButton,"garden", true)

    table.insert(minigameM.currentMinigame.activeData.buttons, newButton)

end

-- Water --

function minigameM:waterPreStart()
    local progressBar = {
        sprite = util.sprites:getSprite("water_progress_bar"),
        x = love.graphics:getWidth()/2,
        y = love.graphics:getHeight()*1.5,
        scaleX = 0.5,
        scaleY = 0.5
    }

    local progressGague = {
        sprite = util.sprites:getSprite("water_progress_gague"),
        x = love.graphics:getWidth()/2,
        y = love.graphics:getHeight()*1.5,
        scaleX = 0.5,
        scaleY = 0.5
    }

    local wateringCan = {
        sprite = util.sprites:getSprite("watering_can"),
        x = love.graphics:getWidth()/1.4,
        y = -love.graphics:getHeight()*1.5,
        rot = 0,
        scaleX = 1,
        scaleY = 1
    }

    minigameM.currentMinigame.activeData = {
        progressBar =  progressBar,
        wateringCan = wateringCan,
        progressGague = progressGague,
        progress = 50
    }
    

    util.tween:tweenProperty(progressBar, "y", love.graphics:getHeight()/1.2, 1, "waterProgressBarY", "out")
    util.tween:tweenProperty(progressGague, "y", love.graphics:getHeight()/1.2, 1, "waterProgressGagueY", "out")
    util.tween:tweenProperty(wateringCan, "y", love.graphics:getHeight()/5, 1, "wateringCanY", "out")
end

function minigameM:waterStart()
    if not minigameM.currentMinigame then
        return
    end
end

local waterSpeed = 0.5
local accel = 0
function minigameM:waterRun(dt)
    print(accel)

    if love.mouse.isDown(1) then
        accel = accel + 0.05
        minigameM.currentMinigame.activeData.progress = clamp(0 , minigameM.currentMinigame.activeData.progress + waterSpeed*accel, 100)
    else
        accel = accel - 0.05
        minigameM.currentMinigame.activeData.progress = clamp(0 , minigameM.currentMinigame.activeData.progress - waterSpeed, 100)
    end 

    accel = clamp(0, accel, 3)
end

function minigameM:waterDraw()
    local o = minigameM.currentMinigame.activeData.progressBar

    love.graphics.draw(o.sprite, o.x, o.y, 0, o.scaleX*cam.zoom,o.scaleY*cam.zoom, o.sprite:getWidth()/2, o.sprite:getHeight()/2)

    o = minigameM.currentMinigame.activeData.progressGague

    local gagueOffset = ((minigameM.currentMinigame.activeData.progress - 50) * 0.88) * cam.zoom

    love.graphics.draw(o.sprite, o.x + gagueOffset, o.y, 0, o.scaleX*cam.zoom,o.scaleY*cam.zoom, o.sprite:getWidth()/2, o.sprite:getHeight()/2)


    o = minigameM.currentMinigame.activeData.wateringCan

    love.graphics.draw(o.sprite, o.x, o.y, math.rad(o.rot), o.scaleX*cam.zoom,o.scaleY*cam.zoom, o.sprite:getWidth()/1.1, 0)
end

return minigameM