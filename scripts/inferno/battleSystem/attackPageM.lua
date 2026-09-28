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
    
    local lookup = attackPageM.registeredPages[id]
    local newSlots = {}

    for k,v in pairs(lookup.slots) do
        local nSlot = {
            value = v.value,
            contains = nil
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
        x = 0,
        y = 0
    }

    return newPage
end

function attackPageM:renderPage(page)
    love.graphics.draw(page.sprite, page.x, page.y, 0, cam.zoom/1.3, cam.zoom/1.3)
end

return attackPageM