local indexM = {}

indexM.lectern = nil
indexM.indexOpen = false

indexM.book = nil

indexM.pages = {}

indexM.currentPage = 1

function indexM:load()
    util.eventM:await("enemiesLoaded", function ()
        indexM:populatePages() 
    end)
    


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

function indexM:populatePages()
    for a,b in pairs(enemyM.registeredEnemies) do
        for _,i in pairs(b) do
            local newPage = {
                name = lang.enemyData[i.name].name.text,
                sprite = util.sprites:getSprite(i.name),
                texts = {
                    nameText = util.text:createText("indexNameText", lang.enemyData[i.name].name.text, util.sprites.pallets.dialogueText, 550,true, false),
                    healthText = util.text:createText("indexHealthText", "Health: ".. tostring(i.health), util.sprites.pallets.red, 77,true, false),
                    shieldText = util.text:createText("indexShieldText", "Shield: ".. tostring(i.shield), util.sprites.pallets.blue, 77,true, false),
                    descriptionText = util.text:createText("indexDescriptionText", lang.enemyData[i.name].description.text, util.sprites.pallets.dialogueText, 170,true, true)
                }
                
            }

            newPage.texts.nameText.scaleX = cam.zoom/1.75
            newPage.texts.nameText.scaleY = cam.zoom/1.75
            newPage.texts.nameText.rot = -0.1

            newPage.texts.healthText.scaleX = cam.zoom/2.5
            newPage.texts.healthText.scaleY = cam.zoom/2.5

            newPage.texts.shieldText.scaleX = cam.zoom/2.5
            newPage.texts.shieldText.scaleY = cam.zoom/2.5

            newPage.texts.descriptionText.scaleX = cam.zoom/2.5
            newPage.texts.descriptionText.scaleY = cam.zoom/2.5

            table.insert(indexM.pages, newPage)
        end    
    end
end

function indexM:update(dt)
    indexM.pages[indexM.currentPage].texts.nameText.x = 600
    indexM.pages[indexM.currentPage].texts.nameText.y = 240 + indexM.book.offsetY

    indexM.pages[indexM.currentPage].texts.healthText.x = 765
    indexM.pages[indexM.currentPage].texts.healthText.y = 280 + indexM.book.offsetY

    indexM.pages[indexM.currentPage].texts.shieldText.x = 765
    indexM.pages[indexM.currentPage].texts.shieldText.y = 320 + indexM.book.offsetY

    indexM.pages[indexM.currentPage].texts.descriptionText.x = 960
    indexM.pages[indexM.currentPage].texts.descriptionText.y = 220 + indexM.book.offsetY
end

function indexM:draw()
    util.sprites:drawObject(indexM.lectern)
end

function indexM:drawUI()

    love.graphics.draw(indexM.book.sprite, indexM.book.x + (40*cam.zoom), indexM.book.y + indexM.book.offsetY, 0, cam.zoom, cam.zoom,
        indexM.book.sprite:getWidth()/2, indexM.book.sprite:getHeight()/2)

    -- Draw Page
    local s = 30
    local scale = math.min(
        s / indexM.pages[indexM.currentPage].sprite:getWidth(),
        s / indexM.pages[indexM.currentPage].sprite:getHeight()
    )

    love.graphics.draw(indexM.pages[indexM.currentPage].sprite, indexM.book.x + (-10*cam.zoom), indexM.book.y + indexM.book.offsetY - (20*cam.zoom), 0,scale* cam.zoom,scale* cam.zoom,
        indexM.pages[indexM.currentPage].sprite:getWidth()/2, indexM.pages[indexM.currentPage].sprite:getHeight()/2)
    
    for _,i in pairs(indexM.pages[indexM.currentPage].texts) do
        i:draw()
    end
end

return indexM