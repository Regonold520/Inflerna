local passiveM = {}

passiveM.registeredPassives = {}

function passiveM:load()
    passiveM:registerPassives()
end

function passiveM:registerPassives()
    passiveM:registerPassive("kindnessOverload", 1)
    passiveM:registerPassive("chastityOverload", 1)
    passiveM:registerPassive("charityOverload", 1)
    passiveM:registerPassive("patienceOverload", 1)
    passiveM:registerPassive("diligenceOverload", 1)
    passiveM:registerPassive("temperanceOverload", 1)
    passiveM:registerPassive("humilityOverload", 1)
end

function passiveM:update(dt)

end

function passiveM:registerPassive(id, cost)
    local newPassive = {
        id = id,
        cost = cost
    }

    passiveM.registeredPassives[id] = newPassive
    return newPassive
end

function passiveM:createPassive(id)
    local passiveCode = require("scripts/inferno/battleSystem/passives/".. id) or nil
    local lookup = passiveM.registeredPassives[id]
    local passiveLang = lang.passives[id]

    local newPassive = {
        id = lookup.id,
        cost = lookup.cost,
        name = passiveLang.name,
        desc = passiveLang.desc,
        code = passiveCode
    }

    return newPassive
end

return passiveM