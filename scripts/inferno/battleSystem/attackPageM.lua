local attackPageM = {}

attackPageM.registeredPages = {}

function attackPageM:load()
    attackPageM:registerPages()
end

function attackPageM:registerPages()
    attackPageM:registerPage("bloom", {
        {value = 5}, {value = 3}
    })
end

function attackPageM:update(dt)
    
end

function attackPageM:registerPage(id, slots)
    local newPage = {
        id = id,
        slots = slots
    }

    attackPageM.registeredPages[id] = newPage
    return newPage
end

function attackPageM:createPage(id)
    local pageCode = require("scripts/inferno/battleSystem/attackPages/".. id) or nil
    local pageLang = lang.attackPages[id]
    local pageId = love.math.random()
    
    local lookup = attackPageM.registeredPages[id]
    local newSlots = {}

    for k,v in pairs(lookup.slots) do
        local nSlot = {
            value = v.value,
            contains = nil,
            valueText = util.text:createText("pageValueText".. tostring(pageId), tostring(v.value), util.sprites.pallets.dialogueText, 75,false, false)
        }
        table.insert(newSlots, nSlot)
    end 
    
    local newPage = {
        code = pageCode,
        id = id,
        slots = newSlots,
        name = pageLang.name,
        desc = pageLang.desc,
        sprite = util.sprites:getSprite(id),
        x = 500,
        y = 300,
        scaleX = 0.7,
        scaleY = 0.7,
        offsetX = 0,
        offsetY = 0,
        deedRolls = nil,
        nameText = util.text:createText("pageText".. tostring(pageId), pageLang.name, util.sprites.pallets.dialogueText, 75,false, false),
        slotsElement = {
            x = 0,
            y = cam.zoom*2,
            sprite = util.sprites:getSprite("cardSlotsBG"),
            label = util.text:createText("pageTextSlots".. tostring(pageId), "Rollables", util.sprites.pallets.dialogueText, 65,false, false),
        },
        pageId = pageId,
        rollableVirtues = {"charity"},
        showContext = true
    }

    newPage.nameText.scaleX = cam.zoom/2.5
    newPage.nameText.scaleY = cam.zoom/2.5
    newPage.nameText.rot = math.rad(-5)

    newPage.slotsElement.label.scaleX = cam.zoom/2.75
    newPage.slotsElement.label.scaleY = cam.zoom/2.75

    newPage.onHoverEnter = function()
        if newPage.showContext then
            util.tween:tweenProperty(newPage, "offsetX", -70, 0.15, "pageLeftTween".. pageId, "out")
            util.tween:tweenProperty(newPage.slotsElement, "x", 90, 0.15, "pageRightTween".. pageId, "out")
        end
    end

    newPage.onHoverExit = function()
        if newPage.showContext then
            util.tween:tweenProperty(newPage, "offsetX", 0, 0.1, "pageLeftTween".. pageId, "out")
            util.tween:tweenProperty(newPage.slotsElement, "x", 0, 0.1, "pageRightTween".. pageId, "out")
        end
    end

    util.input:addClickable(newPage,"garden", true)

    return newPage
end

function attackPageM:queryRolls(page)
    local collatedRolls = {}

    for k,v in pairs(page.rollableVirtues) do
        table.insert(collatedRolls, v)
    end

    if page.deedRolls ~= nil then
        for k,v in pairs(page.deedRolls) do
            table.insert(collatedRolls, v)
        end
    end

    return collatedRolls
end

function attackPageM:renderPage(page)
    local pageOX = page.sprite:getWidth()/2
    local pageOY = page.sprite:getHeight()/2
    love.graphics.draw(page.slotsElement.sprite, page.x + page.slotsElement.x, page.y + page.slotsElement.y + page.offsetY, 0, cam.zoom/1.3, cam.zoom/1.3,pageOX ,pageOY )
    
    page.slotsElement.label.x = page.x + page.slotsElement.x - 15
    page.slotsElement.label.y =  page.y + page.slotsElement.y + page.offsetY - 85

    local pagesRolls = attackPageM:queryRolls(page)

    for k,v in pairs(pagesRolls) do
        local rollableSprite = util.sprites:getSprite(v.. "_pageVirtue")

        local nX = page.x + page.slotsElement.x + 17 + (((k-1)%2 )*50)
        local nY = page.y + page.slotsElement.y + page.offsetY + 50 + ((math.floor((k-1) / 2))*50)

        love.graphics.draw(rollableSprite, nX,nY, rot, cam.zoom/1.3, cam.zoom/1.3,pageOX ,pageOY )
    end 

    page.slotsElement.label:draw()

    love.graphics.draw(page.sprite, page.x + page.offsetX, page.y + page.offsetY, 0, cam.zoom/1.3, cam.zoom/1.3,pageOX ,pageOY )

    page.nameText.x = page.x + page.offsetX
    page.nameText.y = page.y + page.offsetY - 85

    page.nameText:draw()

    

    for k,v in pairs(page.slots) do
        local slotSprite = util.sprites:getSprite("empty_pageVirtue")
        

        v.valueText.changePallet(util.sprites.pallets.dialogueText)

        if v.contains ~= nil then
            slotSprite = util.sprites:getSprite(v.contains.. "_pageVirtue")
            v.valueText.changePallet(util.sprites.pallets[v.contains])
        end

        love.graphics.draw(slotSprite, page.x + page.offsetX + ((k-1)*50) + 12, page.y + page.offsetY + 181, rot, cam.zoom/1.3, cam.zoom/1.3,pageOX ,pageOY )

        v.valueText.x = page.x + page.offsetX + ((k-1)*50) - 50
        v.valueText.y = page.y + page.offsetY + 86

        v.valueText.scaleX = cam.zoom/2.5
        v.valueText.scaleY = cam.zoom/2.5

        v.valueText:draw()
    end
end

function attackPageM:rollPage(page)
    local pagesRolls = attackPageM:queryRolls(page)

    for k,v in pairs(page.slots) do
        local chosenV = pagesRolls[math.random(#pagesRolls)]

        v.contains = chosenV
    end
end

return attackPageM