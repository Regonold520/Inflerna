local gardenM = {}

gardenM.cameraStatic = false

function gardenM:load()

end

function gardenM:update(dt)
    local addX = 0
    if util.tween.activeTweens.camTweenX ~= nil then
        addX = util.tween.activeTweens.camTweenX.value
    end

    local addY = 0
    if util.tween.activeTweens.camTweenY ~= nil then
        addY = util.tween.activeTweens.camTweenY.value
    end

    local mX = 0
    local mY = 0
    if gardenM.cameraStatic == false then
        mX = ((love.mouse.getX() - love.graphics:getWidth() / 2)/40)
        mY = ((love.mouse.getY() - love.graphics:getHeight() / 2)/40)
    end

    cam.projX = addX
    cam.x = clamp(-50, mX + addX, 390)
    cam.y = -10 + mY + addY + cam.yAddition

end

function gardenM:draw()

end

function gardenM:keypressed(key, scancode, isrepeat)
    if gardenM.cameraStatic == false then
        if key == "d" then
            util.tween:createTween(cam.projX, 390, 2, "camTweenX", "out")
        end

        if key == "a" then
            util.tween:createTween(cam.projX, 0, 2, "camTweenX", "out")
        end
    end
end

return gardenM