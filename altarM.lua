local altarM = {}

altarM.vignetteZoomMult = 4
altarM.slotsZoomMult = 4
altarM.altarGuiEnabled = false

altarM.virtueButtons = {}

altarM.slots = {}

altarM.occupiedSeed = nil
altarM.pendingSeeds = {}

function altarM:load()
    altarM.altar = {
        x=util.sprites:getSprite("eden_bg"):getWidth()/2 + util.sprites:getSprite("altar_bg"):getWidth()/2,
        y=-30,
        sprite = util.sprites:getSprite("altar"),
        unlitSprite = util.sprites:getSprite("unlit_altar")
    }

    altarM.altar.onClick = function()
        if altarM.altarGuiEnabled == false and altarM.occupiedSeed == nil then
            util.tween:tweenProperty(altarM,"vignetteZoomMult" , 1.1, 1, "vignetteZoom", "out")
            util.tween:tweenProperty(altarM,"slotsZoomMult" , 1.1, 1, "slotsZoom", "out")
            util.tween:tweenProperty(cam,"zoomModifier" , 1.2, 1, "altarZoomIn", "out")
            util.tween:tweenProperty(cam,"yAddition" , -10,1.5, "altarRiseUp", "out")
            util.tween:tweenProperty(altarM.slots.primary,"y" , 0,1.5, "primaryFall", "out")
            util.tween:tweenProperty(altarM.slots.secondary,"y" , -200,1.6, "secondaryFall", "out")
            util.tween:tweenProperty(altarM.slots.tertiary,"y" , -200,1.7, "tertiaryFall", "out")
            

            gardenM.cameraStatic = true
            altarM.altarGuiEnabled = true
        end
    end

    input:addClickable(altarM.altar,"garden")

    altarM.confirmButton = {
        sprite = util.sprites:getSprite("altar_confirmbutton"),
        x = 0,
        y = -22,
        sinY = 0,
        rot = 0
    }

    altarM.confirmButton.onClick = function()
        if altarM.occupiedSeed == nil and altarM.altarGuiEnabled and altarM.slots.primary.virtue ~= nil then
            local newV2 = altarM.slots.secondary.virtue or altarM.slots.primary.virtue
            local newV3 = altarM.slots.tertiary.virtue or altarM.slots.primary.virtue

            local flowerData = {
                v1 = altarM.slots.primary.virtue,
                v2 = newV2,
                v3 = newV3,
                virtueList = {altarM.slots.primary.virtue},
                chosenColour = nil
            }

            flowerData.chosenColour = flowerData.virtueList[ math.random( #flowerData.virtueList ) ]

            local blessedSeed = flowerM:generateSeed(flowerData)
            altarM.occupiedSeed = blessedSeed

            blessedSeed.onClick = function()
                if altarM.occupiedSeed == nil then
                    return
                end
                for p,p1 in ipairs(flowerM.pots) do
                    if p1.flower == nil and p1.scheduledSeed == nil then
                        p1.scheduledSeed = altarM.occupiedSeed
                        altarM.occupiedSeed.clicked = true
                        util.tween:tweenProperty(altarM.occupiedSeed,"x" , p1.x, 0.6, "altarSeedX", "out")
                        util.tween:tweenProperty(altarM.occupiedSeed,"y" , p1.y - 10, 0.6, "altarSeedY", "out")

                        table.insert(altarM.pendingSeeds, altarM.occupiedSeed)
                        altarM.occupiedSeed = nil
                        break
                    end
                end
            end

            

            input:addClickable(blessedSeed,"garden")

            util.tween:tweenProperty(altarM,"vignetteZoomMult" , 4, 1, "vignetteZoom", "out")
            util.tween:tweenProperty(altarM,"slotsZoomMult" , 4, 1, "slotsZoom", "out")
            util.tween:tweenProperty(cam,"zoomModifier" , 1, 1, "altarZoomIn", "out")
            util.tween:tweenProperty(cam,"yAddition" , 0,1.5, "altarRiseUp", "out")
            util.tween:tweenProperty(altarM.slots.primary,"y" , -love.graphics:getHeight(),1.5, "primaryFall", "out")
            util.tween:tweenProperty(altarM.slots.secondary,"y" , -love.graphics:getHeight(),1.6, "secondaryFall", "out")
            util.tween:tweenProperty(altarM.slots.tertiary,"y" , -love.graphics:getHeight(),1.7, "tertiaryFall", "out")
            

            gardenM.cameraStatic = false
            altarM.altarGuiEnabled = false

            altarM.slots.primary.virtue = nil
            altarM.slots.primary.sprite = altarM.slots.primary.blankSprite

            altarM.slots.secondary.virtue = nil
            altarM.slots.secondary.sprite = altarM.slots.secondary.blankSprite

            altarM.slots.tertiary.virtue = nil
            altarM.slots.tertiary.sprite = altarM.slots.tertiary.blankSprite
        end

    end 

    input:addClickable(altarM.confirmButton,"garden")


    altarM:populateVirtueButtons()
    altarM:populateSlots()
end

function altarM:populateVirtueButtons()
    for v, v1 in pairs(flowerM.virtues) do
        local newV = {
            x = 0,
            y = 0,
            rot = 0,
            sprite = util.sprites:getSprite(v1 .. "-icon"),
            virtue = v1
        }
        
        newV.onClick = function()
            local removed = false
            
            for slotName, slot in pairs(altarM.slots) do
                if slot.virtue == v1 then
                    slot.virtue = nil
                    slot.sprite = slot.blankSprite
                    removed = true
                    
                    local targetRot = math.deg(slot.rot) < 180 and math.rad(360) or 0
                    util.tween:tweenProperty(slot, "rot", targetRot, 0.7, slotName .. "Spin", "out")
                    break 
                end
            end
            
            if not removed then
                local order = {"primary", "secondary", "tertiary"}
                for _, name in ipairs(order) do
                    local slot = altarM.slots[name]
                    if slot.virtue == nil then
                        slot.virtue = v1
                        slot.sprite = util.sprites:getSprite(v1 .. "-icon")

                        local targetRot = math.deg(slot.rot) < 180 and math.rad(360) or 0
                        util.tween:tweenProperty(slot, "rot", targetRot, 0.7, name .. "Spin", "out")
                        break
                    end
                end
            end
        end
        
        table.insert(altarM.virtueButtons, newV)
        input:addClickable(newV,"garden", true)
    end
end

function altarM:populateSlots()
    local primarySlot = {
        idx = 1,
        x = 0,
        y = -love.graphics:getHeight(),
        blankSprite = util.sprites:getSprite("altar_slot1"),
        sprite = util.sprites:getSprite("altar_slot1"),
        rot = 0,
        virtue = nil,
        sinY = 0
    }

    local secondarySlot = {
        idx = 1,
        x = -200,
        y = -love.graphics:getHeight(),
        blankSprite = util.sprites:getSprite("altar_slot2"),
        sprite = util.sprites:getSprite("altar_slot2"),
        rot = 0,
        virtue = nil,
        sinY = 0
    }

    local tertiarySlot = {
        idx = 1,
        x = 200,
        y = -love.graphics:getHeight(),
        blankSprite = util.sprites:getSprite("altar_slot3"),
        sprite = util.sprites:getSprite("altar_slot3"),
        rot = 0,
        virtue = nil,
        sinY = 0
    }

    altarM.slots.primary = primarySlot
    altarM.slots.secondary = secondarySlot
    altarM.slots.tertiary = tertiarySlot
end

local deltaTimer = 0
function altarM:update(dt)
    deltaTimer = deltaTimer + dt
    altarM.slots.primary.sinY = math.cos(deltaTimer*3)*8
    altarM.slots.secondary.sinY = math.cos(deltaTimer*3+10)*8
    altarM.slots.tertiary.sinY = math.cos(deltaTimer*3+20)*8

    altarM.confirmButton.sinY = math.cos(deltaTimer*2 + 50)
    altarM.confirmButton.rot = math.sin(deltaTimer*2 + 50) / 10

    if util.tween.activeTweens.altarZoomIn ~= nil then
        cam.zoomModifier = util.tween.activeTweens.altarZoomIn.value
    end

    if util.tween.activeTweens.altarRiseUp ~= nil then
        cam.yAddition = util.tween.activeTweens.altarRiseUp.value
    end
end

function altarM:draw()
    love.graphics.draw(util.sprites:getSprite("altar_bg"), util.sprites:getSprite("eden_bg"):getWidth()/2 , 0, 0, 1, 1, 0, util.sprites:getSprite("altar_bg"):getHeight()/2)
    
    local altSprite = altarM.altar.unlitSprite

    if altarM.altarGuiEnabled then
        altSprite = altarM.altar.sprite
    end
    
    love.graphics.draw(altSprite,altarM.altar.x, altarM.altar.y, 0, 1, 1, altarM.altar.sprite:getWidth()/2, altarM.altar.sprite:getHeight()/2)

    if altarM.occupiedSeed ~= nil then
        if altarM.occupiedSeed.clicked == false then 
            altarM.occupiedSeed.x = altarM.altar.x
            altarM.occupiedSeed.y = altarM.altar.y + 15
        end
        love.graphics.draw(altarM.occupiedSeed.sprite,altarM.occupiedSeed.x,altarM.occupiedSeed.y , 0, 1, 1, altarM.occupiedSeed.sprite:getWidth()/2, altarM.occupiedSeed.sprite:getHeight()/2)
    end

    for s,s1 in pairs(altarM.pendingSeeds) do
        if s1.clicked == false then 
            s1.x = altarM.altar.x
            s1.y = altarM.altar.y + 15
        end
        love.graphics.draw(s1.sprite,s1.x,s1.y , 0, 1, 1, s1.sprite:getWidth()/2, s1.sprite:getHeight()/2)

    end
    
    local obj = altarM.confirmButton
    if altarM.altarGuiEnabled and altarM.slots.primary.virtue ~= nil then
        if obj ~= nil then
            obj.x = altarM.altar.x
            obj.y = altarM.altar.y + obj.sinY - 26
            love.graphics.draw(obj.sprite,obj.x, obj.y+5, obj.rot, 1, 1, obj.sprite:getWidth()/2, obj.sprite:getHeight()/2)
        end
    end
end

function altarM:drawAltarVirtues()
    local pointCount = 12
    
    local mult = altarM.vignetteZoomMult
    if util.tween.activeTweens.vignetteZoom ~= nil then
        mult = util.tween.activeTweens.vignetteZoom.value
    end
    mult = mult -0.1

    local mult2 = altarM.slotsZoomMult
    if util.tween.activeTweens.slotsZoom ~= nil then
        mult2 = util.tween.activeTweens.slotsZoom.value
    end
    mult2 = mult2 -0.1

    local count = 3

    for v,v1 in pairs(altarM.virtueButtons) do
        v1.x = love.graphics:getWidth()/2 + (math.sin(math.rad((360- ((360/pointCount)*count))))*(370*mult2))
        v1.y = love.graphics:getHeight()/2 + (math.cos(math.rad((360- ((360/pointCount)*count))))*(370*mult2))-(10*cam.zoom)

        love.graphics.draw(v1.sprite, 
            v1.x, 
            v1.y,
            v1.rot,
            cam.zoom,
            cam.zoom,
            v1.sprite:getWidth() /2 , v1.sprite:getHeight()/2)
        count = count - 1
    end
end

function altarM:drawUI()
    local mult = altarM.vignetteZoomMult
    if util.tween.activeTweens.vignetteZoom ~= nil then
        mult = util.tween.activeTweens.vignetteZoom.value
    end

    love.graphics.draw(util.sprites:getSprite("altar_vignette"), love.graphics.getWidth() / 2, love.graphics.getHeight()/2, 0, cam.zoom*mult, cam.zoom*mult, util.sprites:getSprite("altar_vignette"):getWidth()/2, util.sprites:getSprite("altar_vignette"):getHeight()/2)
    altarM:drawAltarVirtues()

    local obj = altarM.slots.primary
    if obj ~= nil then
        love.graphics.draw(obj.sprite,love.graphics.getWidth() / 2 + obj.x, love.graphics.getHeight()/2 + obj.y + obj.sinY, obj.rot, cam.zoom, cam.zoom,
            obj.sprite:getWidth()/2, obj.sprite:getHeight()/2)
    end

    obj = altarM.slots.secondary
    if obj ~= nil then
        love.graphics.draw(obj.sprite,love.graphics.getWidth() / 2 + obj.x, love.graphics.getHeight()/2 + obj.y + obj.sinY, obj.rot, cam.zoom, cam.zoom,
            obj.sprite:getWidth()/2, obj.sprite:getHeight()/2)
    end

    obj = altarM.slots.tertiary
    if obj ~= nil then
        love.graphics.draw(obj.sprite,love.graphics.getWidth() / 2 + obj.x, love.graphics.getHeight()/2 + obj.y + obj.sinY, obj.rot, cam.zoom, cam.zoom,
            obj.sprite:getWidth()/2, obj.sprite:getHeight()/2)
    end


    
end

return altarM