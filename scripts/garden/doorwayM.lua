local doorwayM = {}

doorwayM.exitMenuOpen = false

doorwayM.exitFlowerSelectButtons = {}

doorwayM.party = {}
doorwayM.endSequence = false

function doorwayM:load()
    doorwayM.door = {
        x=-(util.sprites:getSprite("eden_bg"):getWidth()/2 + util.sprites:getSprite("altar_bg"):getWidth()/2),
        y=-38.5,
        sprite = util.sprites:getSprite("inferno_door"),
        openSprite = util.sprites:getSprite("inferno_door_unlocked"),
        chainSprite = util.sprites:getSprite("inferno_door_chains")
    }

    

    util.input:addClickable(doorwayM.door,"garden")

    doorwayM.door.onClick = function()
        if not doorwayM.endSequence and cam.roomPos == -1 then
            if not doorwayM.exitMenuOpen then
                doorwayM:openExitPanel()
                util.tween:tweenProperty(altarM,"vignetteZoomMult" , 1.1, 1, "vignetteZoom", "out")
                util.tween:tweenProperty(cam,"zoomModifier" , 1.15, 1, "altarZoomIn", "out")
                util.tween:tweenProperty(cam,"yAddition" , -10,1.5, "altarRiseUp", "out")
                util.tween:tweenProperty(doorwayM.exitPanel,"yMove" , 100,1, "exitPanelYmove", "out")
                doorwayM.exitPanel.page = 1

                gardenM.cameraStatic = true
                doorwayM.exitMenuOpen = true
            else
                util.tween:tweenProperty(altarM,"vignetteZoomMult" , 4, 1, "vignetteZoom", "out")
                util.tween:tweenProperty(cam,"zoomModifier" , 1, 1, "altarZoomIn", "out")
                util.tween:tweenProperty(cam,"yAddition" , 0,1.5, "altarRiseUp", "out")
                util.tween:tweenProperty(doorwayM.exitPanel,"yMove" , -love.graphics.getHeight(),1, "exitPanelYmove", "out")

                gardenM.cameraStatic = false
                doorwayM.exitMenuOpen = false

                doorwayM.party = {}
            end
        end
    end

    doorwayM.exitPanel = {
        x = (love.graphics.getWidth()/2) - 450,
        y = (love.graphics.getHeight()/2) - 500,
        yMove = -love.graphics.getHeight(),
        sprite = util.sprites:getSprite("inferno_enter_panel"),
        bloomedFlowers = {},
        page = 1,
        layer = 0
    }

    doorwayM.exitPanel.onClick = function() end

    util.input:addClickable(doorwayM.exitPanel,"garden", true)

    doorwayM.exitPanelPgL = {
        x=doorwayM.exitPanel.x - 170,
        y=doorwayM.exitPanel.y,
        sprite = util.sprites:getSprite("page_turn_l"),
        layer = 1
    }

    doorwayM.exitPanelPgL.onClick = function()
        doorwayM.exitPanel.page = clamp(1, doorwayM.exitPanel.page - 1, math.ceil(#doorwayM.exitPanel.bloomedFlowers / 6))
    end

    doorwayM.exitPanelPgR = {
        x=doorwayM.exitPanel.x - 135,
        y=doorwayM.exitPanel.y - 40,
        sprite = util.sprites:getSprite("page_turn_r"),
        layer = 1
    }

    doorwayM.exitPanelPgR.onClick = function()
        doorwayM.exitPanel.page = clamp(1, doorwayM.exitPanel.page + 1, math.ceil(#doorwayM.exitPanel.bloomedFlowers / 6))
    end



    doorwayM.exitPanelLeave = {
        x=doorwayM.exitPanel.x - 58,
        y=doorwayM.exitPanel.y - 40,
        inactiveSprite = util.sprites:getSprite("inferno_enter_inactive"),
        sprite = util.sprites:getSprite("inferno_enter_active"),
        layer = 1,
        rot = 0
    }

    doorwayM.exitPanelLeave.onClick = function()
        if #doorwayM.party > 0 then
            doorwayM.endSequence = true

            --util.tween:tweenProperty(cam,"zoomModifier" , 1, 1, "altarZoomIn", "out")
            util.tween:tweenProperty(doorwayM.exitPanel,"yMove" , -love.graphics.getHeight(),1, "exitPanelYmove", "out")

            util.time:runDeferred(1, function() sceneM:switchScene("inferno") end)
        end
    end

    util.input:addClickable(doorwayM.exitPanelPgL,"garden", true)
    util.input:addClickable(doorwayM.exitPanelPgR,"garden", true)
    util.input:addClickable(doorwayM.exitPanelLeave,"garden", true)
end

function doorwayM:update()
    doorwayM.exitPanel.y = (love.graphics.getHeight()/2) - 200 + doorwayM.exitPanel.yMove
    doorwayM.exitPanelPgL.y = doorwayM.exitPanel.y - 40
    doorwayM.exitPanelPgR.y = doorwayM.exitPanel.y - 40

    doorwayM.exitPanelLeave.y = doorwayM.exitPanel.y + 77

    doorwayM:positionFlowers()
end

function doorwayM:openExitPanel()
    doorwayM.exitPanel.bloomedFlowers = flowerM:getBloomedFlowers() 
    doorwayM.exitFlowerSelectButtons = {}

    if util.dialogue.tutorial.fullyComplete == false and util.dialogue.tutorial.doorwaySelect == false and util.dialogue.tutorial.doorwayEnter then
        util.dialogue.tutorial.doorwaySelect = true
        util.dialogue.tutorial.fullyComplete = true
        util.dialogue:initiateDialogue("virgil", "doorwaySelect")
    end

    for f,f1 in pairs(doorwayM.exitPanel.bloomedFlowers) do
        local newB = {
            isSelected = false,
            x = 0,
            y = 0,
            sprite = util.sprites:getSprite("flowerBGButton"),
            id = #doorwayM.exitFlowerSelectButtons + 1,
            layer = 1,
            linkedFlower = f1
        }
        
        newB.onClick = function()

            if newB.id >= (doorwayM.exitPanel.page*6)-5 and newB.id <= (doorwayM.exitPanel.page*6) then

                if newB.isSelected then
                    newB.isSelected = false
                    for p,p1 in pairs(doorwayM.party) do
                        if p1.uuid == newB.linkedFlower.uuid then
                            table.remove(doorwayM.party,p)
                            if #doorwayM.party <= 0 then
                                util.tween:tweenProperty(doorwayM.exitPanelLeave,"rot" , math.rad(0), 1, "infernoLeaveRot", "out")
                            end
                        end
                    end
                else
                    if #doorwayM.party < 4 then
                        newB.isSelected = true
                        table.insert(doorwayM.party, flowerM:cloneFlower(f1))
                    end
                    if #doorwayM.party == 1 then
                        util.tween:tweenProperty(doorwayM.exitPanelLeave,"rot" , math.rad(360), 1,  "infernoLeaveRot", "out")
                    end
                end
            end
        end

        util.input:addClickable(newB,"garden", true)
        table.insert(doorwayM.exitFlowerSelectButtons, newB)
    end

    doorwayM:positionFlowers()
end

function doorwayM:positionFlowers()
    local bloomedFlowersStart = {
        x = doorwayM.exitPanel.x - doorwayM.exitPanel.sprite:getWidth()*2,
        y = doorwayM.exitPanel.y - doorwayM.exitPanel.sprite:getHeight()*2
    }

    local count = -1
    local yChange = 0

    local relCount = 1
    local pageSize = 6
    local startIndex = (doorwayM.exitPanel.page - 1) * pageSize + 1
    local endIndex = startIndex + pageSize - 1

    for i = startIndex, endIndex do
        local flower = doorwayM.exitPanel.bloomedFlowers[i]
        if not flower then break end

        if count == 2 then
            count = -1
            yChange = yChange + 1
        end

        flower.x = bloomedFlowersStart.x + 130 + (count*80)
        flower.y = bloomedFlowersStart.y + 70 + (yChange*94)

        doorwayM.exitFlowerSelectButtons[i].x = bloomedFlowersStart.x + (count*82)+ 130
        doorwayM.exitFlowerSelectButtons[i].y = bloomedFlowersStart.y + (yChange*94)+32

        count = count + 1
        relCount = relCount + 1
    end

    local count = 0
    for f,f1 in pairs(doorwayM.party) do
        f1.x = bloomedFlowersStart.x + 323 
        f1.y = bloomedFlowersStart.y + 65 + (110*count)
        count = count + 1
    end
end


function doorwayM:draw()
    love.graphics.draw(util.sprites:getSprite("doorway_bg"), -util.sprites:getSprite("eden_bg"):getWidth()/2 - util.sprites:getSprite("doorway_bg"):getWidth() , 0, 0, 1, 1, 0, util.sprites:getSprite("doorway_bg"):getHeight()/2)
    love.graphics.draw(doorwayM.door.chainSprite,doorwayM.door.x, doorwayM.door.y, 0, 1, 1, doorwayM.door.chainSprite:getWidth()/2, doorwayM.door.chainSprite:getHeight()/2)
    
    local doorSprite = doorwayM.door.sprite

    if doorwayM.endSequence then doorSprite = doorwayM.door.openSprite end
    
    love.graphics.draw(doorSprite,doorwayM.door.x, doorwayM.door.y, 0, 1, 1, doorSprite:getWidth()/2, doorSprite:getHeight()/2)
end

function doorwayM:drawUI()
    love.graphics.setColor(1,1,1,1)

    love.graphics.draw(doorwayM.exitPanel.sprite,doorwayM.exitPanel.x ,doorwayM.exitPanel.y, 0, cam.zoom, cam.zoom, doorwayM.exitPanel.sprite:getWidth()/2,doorwayM.exitPanel.sprite:getHeight()/2)

    love.graphics.draw(doorwayM.exitPanelPgL.sprite,doorwayM.exitPanelPgL.x ,doorwayM.exitPanelPgL.y, 0, cam.zoom, cam.zoom, doorwayM.exitPanelPgL.sprite:getWidth()/2,doorwayM.exitPanelPgL.sprite:getHeight()/2)
    love.graphics.draw(doorwayM.exitPanelPgR.sprite,doorwayM.exitPanelPgR.x ,doorwayM.exitPanelPgR.y, 0, cam.zoom, cam.zoom, doorwayM.exitPanelPgR.sprite:getWidth()/2,doorwayM.exitPanelPgR.sprite:getHeight()/2)

    local leaveSprite = doorwayM.exitPanelLeave.inactiveSprite

    if #doorwayM.party > 0 then leaveSprite = doorwayM.exitPanelLeave.sprite end

    love.graphics.draw(leaveSprite,doorwayM.exitPanelLeave.x ,doorwayM.exitPanelLeave.y, doorwayM.exitPanelLeave.rot, cam.zoom, cam.zoom, leaveSprite:getWidth()/2,leaveSprite:getHeight()/2)
    

    local flowerScale = 2.5
    
    local count = -1
    local yChange = 0

    local relCount = 0
    local pageSize = 6
    local startIndex = (doorwayM.exitPanel.page - 1) * pageSize + 1
    local endIndex = startIndex + pageSize - 1
    if doorwayM.exitMenuOpen then
        for i = startIndex, endIndex do
            local flower = doorwayM.exitPanel.bloomedFlowers[i]
            if not flower then break end
            if relCount >= pageSize then
                love.graphics.setColor(1,1,1,1)
                return
            end


            if count == 2 then
                count = -1
                yChange = yChange + 1
            end

            local a = 0.7
            local b = 0
            if doorwayM.exitFlowerSelectButtons[i].isSelected then
                a = 1
                b=0.5
            end

            love.graphics.setColor(0.5, 0.5, 0.5, b )
            if doorwayM.exitFlowerSelectButtons[i].x ~= 0 then
                love.graphics.draw(doorwayM.exitFlowerSelectButtons[i].sprite,doorwayM.exitFlowerSelectButtons[i].x,doorwayM.exitFlowerSelectButtons[i].y  ,0,cam.zoom+0.1,cam.zoom+0.4,
                    doorwayM.exitFlowerSelectButtons[i].sprite:getWidth()/2,doorwayM.exitFlowerSelectButtons[i].sprite:getHeight()/2)
            end

            love.graphics.setColor(a,a,a,1)
            if flower.x ~= love.graphics.getWidth()/2 then
                flowerM:drawIndividualFlower(flower , {scale=flowerScale})
            end
            count = count + 1
            relCount = relCount + 1
        end

        love.graphics.setColor(1,1,1,1)
        for f,f1 in pairs(doorwayM.party) do
            flowerM:drawIndividualFlower(f1 , {scale=2.6})
        end
    end

    love.graphics.setColor(1,1,1,1)
end

return doorwayM