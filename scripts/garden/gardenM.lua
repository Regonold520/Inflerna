local gardenM = {}

gardenM.cameraStatic = false
gardenM.currentTool = ""



function gardenM:load()
    cam.roomPos = 0
    gardenM.wateringCan = {
        x = -100,
        y = -5,
        sprite = util.sprites:getSprite("watering_can"),
        selectedSprite = util.sprites:getSprite("watering_can_selected")
    }

    gardenM.wateringCan.onClick = function()
        gardenM:switchTool("wateringCan")
    end

    util.input:addClickable(gardenM.wateringCan,"garden")
end

gardenM.mX = 0
gardenM.mY = 0
dtimer = 0
function gardenM:update(dt)
    dtimer = dtimer + dt
    
    if gardenM.cameraStatic == false then
        gardenM.mX = ((love.mouse.getX() - love.graphics:getWidth() / 2)/40)
        gardenM.mY = ((love.mouse.getY() - love.graphics:getHeight() / 2)/40)
    elseif gardenM.mX ~= 0 or gardenM.mY ~= 0 then
        util.tween:tweenProperty(gardenM, "mX", 0, 0.5, "GardenMX", "out")
        util.tween:tweenProperty(gardenM, "mY", 0, 0.5, "GardenMY", "out")
    end

    cam.x = clamp(-390, gardenM.mX + cam.projX, 390)
    cam.y = -10 + gardenM.mY  + cam.yAddition

end

function gardenM:draw()
    love.graphics.draw(util.sprites:getSprite("eden_bg"), 0, 0, 0, 1, 1, util.sprites:getSprite("eden_bg"):getWidth()/2, util.sprites:getSprite("eden_bg"):getHeight()/2)
    local waterSprite = gardenM.wateringCan.sprite
    if gardenM.currentTool == "wateringCan" then waterSprite = gardenM.wateringCan.selectedSprite end

    love.graphics.draw(waterSprite, gardenM.wateringCan.x, gardenM.wateringCan.y, 0, 1, 1, gardenM.wateringCan.sprite:getWidth()/2,gardenM.wateringCan.sprite:getHeight()/2)
    
    local wx, wy = getWorldMouse()
    wx = math.floor(wx)
    wy = math.floor(wy)

    



end

function drawPixelCircle(wx, wy, radius)
    local r = math.floor(radius)

    for dx = -r, r do
        for dy = -r, r do
            local dist2 = dx*dx + dy*dy
            if dist2 <= r*r and dist2 >= (r-1)*(r-1) then
                if not (dx == 0 and math.abs(dy) == r) and not (dy == 0 and math.abs(dx) == r) then
                    love.graphics.rectangle(
                        "fill",
                        wx + dx*cam.zoom,      
                        wy + dy*cam.zoom,
                        cam.zoom, 
                        cam.zoom
                    )
                end
            end
        end
    end
end




function gardenM:switchTool(tool)
    local newTool = tool
    if gardenM.currentTool == tool then
        newTool = ""
    end

    gardenM.currentTool = newTool
end

function gardenM:keypressed(key, scancode, isrepeat)
    if gardenM.cameraStatic == false then
        if key == "d" and cam.roomPos + 1 < 2 then
            cam.roomPos = cam.roomPos + 1
            util.tween:tweenProperty(cam,"projX" , 390 * cam.roomPos, 2, "camTweenX", "out")
        end

        if key == "a" and cam.roomPos - 1 > -2 then
            cam.roomPos = cam.roomPos - 1
            util.tween:tweenProperty(cam,"projX" , 390 * cam.roomPos, 2, "camTweenX", "out")
        end
    end

    if cam.roomPos == 1 then
        if util.dialogue.tutorial.fullyComplete == false and util.dialogue.tutorial.altarEnter == false then
            util.dialogue.tutorial.altarEnter = true
            util.time:runDeferred(0.5, function() util.dialogue:initiateDialogue("virgil", "altarEnter") end )
        end
    end
    if cam.roomPos == 0 and util.dialogue.tutorial.seedTransported == true and util.dialogue.tutorial.returnToGarden == false and util.dialogue.tutorial.fullyComplete == false then
        util.dialogue.tutorial.returnToGarden = true
        util.time:runDeferred(0.5, function() util.dialogue:initiateDialogue("virgil", "returnToGarden") end )
    end
    if cam.roomPos == -1 and util.dialogue.tutorial.fullyComplete == false and util.dialogue.tutorial.doorwayEnter == false and util.dialogue.tutorial.flowerBloomed then
        util.dialogue.tutorial.doorwayEnter = true
        util.time:runDeferred(0.5, function() util.dialogue:initiateDialogue("virgil", "doorwayEnter") end )
    end
end

return gardenM