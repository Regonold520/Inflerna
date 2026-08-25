local indexM = {}

indexM.lectern = nil
indexM.indexOpen = false

indexM.book = nil

function indexM:load()
    indexM.lectern = {
        x=util.sprites:getSprite("eden_bg"):getWidth()/2  + 55,
        y=-19,
        sprite = util.sprites:getSprite("lectern"),
    }

    indexM.lectern.onClick = function ()
        if cam.roomPos == 1 and altarM.altarGuiEnabled == false then

            if indexM.indexOpen then
            indexM.indexOpen = false

                util.tween:tweenProperty(altarM,"vignetteZoomMult" , 4, 1, "vignetteZoom", "out")
                util.tween:tweenProperty(cam,"zoomModifier" , 1, 1, "altarZoomIn", "out")
                util.tween:tweenProperty(cam,"yAddition" , 0,1.5, "camTweenY", "out")
                util.tween:tweenProperty(cam, "projX", 390, 1.5, "camTweenX", "out")
                util.tween:tweenProperty(indexM.book, "offsetY", -800, 1, "bookTweenY", "out")

                gardenM.cameraStatic = false
            else
                indexM.indexOpen = true

                util.tween:tweenProperty(altarM,"vignetteZoomMult" , 1.5, 1, "vignetteZoom", "out")
                util.tween:tweenProperty(cam,"zoomModifier" , 1.3, 1, "altarZoomIn", "out")
                util.tween:tweenProperty(cam,"yAddition" , -10,1.5, "camTweenY", "out")
                util.tween:tweenProperty(cam, "projX", indexM.lectern.x + 50, 1.5, "camTweenX", "out")
                util.tween:tweenProperty(indexM.book, "offsetY", 0, 1, "bookTweenY", "out")
                

                gardenM.cameraStatic = true
            end

            print(indexM.indexOpen)
        end
    end

    util.input:addClickable(indexM.lectern,"garden")

    indexM.book = {
        x = 1466/2,
        y = 868/2,
        offsetY = -800,
        sprite = util.sprites:getSprite("bookCover")
    }
end

function indexM:update(dt)
end

function indexM:draw()
    util.sprites:drawObject(indexM.lectern)
end

function indexM:drawUI()

    love.graphics.draw(indexM.book.sprite, indexM.book.x + (40*cam.zoom), indexM.book.y + indexM.book.offsetY, 0, cam.zoom, cam.zoom,
        indexM.book.sprite:getWidth()/2, indexM.book.sprite:getHeight()/2)
end

return indexM