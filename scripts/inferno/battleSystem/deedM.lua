local deedM = {}

deedM.registeredDeeds = {}

function deedM:load()
    deedM:registerDeeds()



    local newDeed = deedM:createDeed("kindness")

    print(newDeed.id, #newDeed.passives)
end

function deedM:update(dt)

end

function deedM:registerDeeds()
    deedM:registerDeed("kindness", {"kindness"}, {"kindnessOverload"})
end

function deedM:registerDeed(id, deedRolls, passives)
    local newDeed = {
        id = id,
        deedRolls = deedRolls,
        passives = passives
    }

    deedM.registeredDeeds[id] = newDeed
end

function deedM:createDeed(id)
    local lookup = deedM.registeredDeeds[id]
    local deedLang = lang.deeds[id]

    local newPassives = {}

    for k,v in pairs(lookup.passives) do
        local newPassive = passiveM:createPassive(v)

        table.insert(newPassives, newPassive)
    end

    local newRolls = {}

    for k,v in pairs(lookup.deedRolls) do
        table.insert(newRolls, v)
    end
    
    local newDeed = {
        id = id,
        deedRolls = newRolls,
        name = deedLang.name,
        desc = deedLang.desc,
        passives = newPassives,
        pages = {}
    }

    newDeed.addPage = function(page)
        if #newDeed.pages < 9 then
            local newPage = attackPageM:createPage(page.id)
            newPage.deedRolls = newDeed.deedRolls

            table.insert(newDeed.pages, newPage)
        end
    end

    newDeed.removePage = function(pageId)
        for k,v in pairs(newDeed.pages) do
            if v.id == pageId then
                table.remove(newDeed.pages, k)
            end
        end
    end

    return newDeed
end

return deedM