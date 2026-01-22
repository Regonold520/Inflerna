local doorwayM = {}

function doorwayM:load()
    doorwayM.door = {
        x=-(util.sprites:getSprite("eden_bg"):getWidth()/2 + util.sprites:getSprite("altar_bg"):getWidth()/2),
        y=-38.5,
        sprite = util.sprites:getSprite("inferno_door"),
    }

    

    input:addClickable(doorwayM.door,"garden")

    doorwayM.door.onClick = function()
        util.tween:tweenProperty(altarM,"vignetteZoomMult" , 1.1, 1, "vignetteZoom", "out")
        util.tween:tweenProperty(cam,"zoomModifier" , 1.15, 1, "altarZoomIn", "out")
        util.tween:tweenProperty(cam,"yAddition" , -10,1.5, "altarRiseUp", "out")
        

        gardenM.cameraStatic = true
    end

    doorwayM.exitPanel = {
        x = (love.graphics.getWidth()/2) - 450,
        y = (love.graphics.getHeight()/2) - 100,
        sprite = util.sprites:getSprite("inferno_enter_panel"),
        bloomedFlowers = {}
    }
end

function doorwayM:update()
    doorwayM:openExitPanel()
end

function doorwayM:openExitPanel()
    doorwayM.exitPanel.bloomedFlowers = flowerM:getBloomedFlowers() 
end

function doorwayM:draw()
    love.graphics.draw(util.sprites:getSprite("doorway_bg"), -util.sprites:getSprite("eden_bg"):getWidth()/2 - util.sprites:getSprite("doorway_bg"):getWidth() , 0, 0, 1, 1, 0, util.sprites:getSprite("doorway_bg"):getHeight()/2)
    love.graphics.draw(doorwayM.door.sprite,doorwayM.door.x, doorwayM.door.y, 0, 1, 1, doorwayM.door.sprite:getWidth()/2, doorwayM.door.sprite:getHeight()/2)
end

function doorwayM:drawUI()
    love.graphics.draw(doorwayM.exitPanel.sprite,doorwayM.exitPanel.x ,doorwayM.exitPanel.y, 0, cam.zoom, cam.zoom, doorwayM.exitPanel.sprite:getWidth()/2,doorwayM.exitPanel.sprite:getHeight()/2)
    for _,i in pairs(doorwayM.exitPanel.bloomedFlowers) do
        i.x = love.graphics:getWidth()/4
        flowerM:drawIndividualFlower(i , {scale=4})
    end
end

return doorwayM