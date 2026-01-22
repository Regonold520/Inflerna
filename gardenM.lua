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
        print("walter",gardenM.currentTool)
    end

    input:addClickable(gardenM.wateringCan,"garden")
end

function gardenM:update(dt)

    local mX = 0
    local mY = 0
    if gardenM.cameraStatic == false then
        mX = ((love.mouse.getX() - love.graphics:getWidth() / 2)/40)
        mY = ((love.mouse.getY() - love.graphics:getHeight() / 2)/40)
    end

    cam.x = clamp(-390, mX + cam.projX, 390)
    cam.y = -10 + mY  + cam.yAddition

end

function gardenM:draw()
    love.graphics.draw(util.sprites:getSprite("eden_bg"), 0, 0, 0, 1, 1, util.sprites:getSprite("eden_bg"):getWidth()/2, util.sprites:getSprite("eden_bg"):getHeight()/2)
    local waterSprite = gardenM.wateringCan.sprite
    if gardenM.currentTool == "wateringCan" then waterSprite = gardenM.wateringCan.selectedSprite end

    love.graphics.draw(waterSprite, gardenM.wateringCan.x, gardenM.wateringCan.y, 0, 1, 1, gardenM.wateringCan.sprite:getWidth()/2,gardenM.wateringCan.sprite:getHeight()/2)
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
end

return gardenM