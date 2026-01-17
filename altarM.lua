local altarM = {}

local vignetteZoomMult = 4
altarM.altarGuiEnabled = false

function altarM:load()
    altarM.altar = {
        x=util.sprites:getSprite("eden_bg"):getWidth()/2 + util.sprites:getSprite("altar_bg"):getWidth()/2,
        y=-30,
        sprite = util.sprites:getSprite("altar")
    }

    altarM.altar.onClick = function()
        if altarM.altarGuiEnabled == false then
            util.tween:createTween(vignetteZoomMult, 1.1, 1, "vignetteZoom", "out")
            util.tween:createTween(cam.zoomModifier, 1.2, 1, "altarZoomIn", "out")
            util.tween:createTween(cam.yAddition,-10,1.5, "altarRiseUp", "out")
            gardenM.cameraStatic = true
            altarM.altarGuiEnabled = true
        end
    end

    input:addClickable(altarM.altar)
end

function altarM:update(dt)
    if util.tween.activeTweens.altarZoomIn ~= nil then
        cam.zoomModifier = util.tween.activeTweens.altarZoomIn.value
    end

    if util.tween.activeTweens.altarRiseUp ~= nil then
        cam.yAddition = util.tween.activeTweens.altarRiseUp.value
    end
end

function altarM:draw()
    love.graphics.draw(util.sprites:getSprite("altar_bg"), util.sprites:getSprite("eden_bg"):getWidth()/2 , 0, 0, 1, 1, 0, util.sprites:getSprite("altar_bg"):getHeight()/2)
    love.graphics.draw(altarM.altar.sprite,altarM.altar.x, altarM.altar.y, 0, 1, 1, altarM.altar.sprite:getWidth()/2, altarM.altar.sprite:getHeight()/2)
end

function altarM:drawAltarVirtues()
    local pointCount = 12
    
    local mult = vignetteZoomMult
    if util.tween.activeTweens.vignetteZoom ~= nil then
        mult = util.tween.activeTweens.vignetteZoom.value
    end
    mult = mult -0.1

    local count = 3
    for _,i in pairs(flowerM.virtues) do
        local sprite = util.sprites:getSprite(i.."-icon")

        love.graphics.draw(sprite, 
            love.graphics:getWidth()/2 + (math.sin(math.rad((360- ((360/pointCount)*count))))*(370*mult)), 
            love.graphics:getHeight()/2 + (math.cos(math.rad((360- ((360/pointCount)*count))))*(370*mult))-(10*cam.zoom),
            0,
            cam.zoom,
            cam.zoom,
            sprite:getWidth() /2 , sprite:getHeight()/2)
        count = count - 1
    end
    
end

function altarM:drawUI()
    local mult = vignetteZoomMult
    if util.tween.activeTweens.vignetteZoom ~= nil then
        mult = util.tween.activeTweens.vignetteZoom.value
    end

    love.graphics.draw(util.sprites:getSprite("altar_vignette"), love.graphics.getWidth() / 2, love.graphics.getHeight()/2, 0, cam.zoom*mult, cam.zoom*mult, util.sprites:getSprite("altar_vignette"):getWidth()/2, util.sprites:getSprite("altar_vignette"):getHeight()/2)
    altarM:drawAltarVirtues()
end

return altarM