local intermission = {}

intermission.shuffleableLayers = {"lust","gluttony","greed","wrath","heresy","violence","fraud"}
intermission.chosenOrder = {"limbo","lust","gluttony","greed","wrath","heresy","violence","fraud","treachery"}

local layerColors = {
    ["limbo"]     = {r = 0.7216, g = 0.7019, b = 0.6630}, -- #b8b3a9
    ["lust"]      = {r = 0.8039, g = 0.3765, b = 0.5765}, -- #cd6093
    ["gluttony"]  = {r = 0.4706, g = 0.5843, b = 0.3530}, -- #78955a
    ["greed"]     = {r = 0.9569, g = 0.7059, b = 0.1059}, -- #f4b41b
    ["wrath"]     = {r = 0.2235, g = 0.4706, b = 0.6588}, -- #3978a8
    ["heresy"]    = {r = 0.6902, g = 0.1725, b = 0.1725}, -- #b02c2c
    ["violence"]  = {r = 1.0000, g = 0.4863, b = 0.1725}, -- #ff7c2c
    ["fraud"]     = {r = 0.5569, g = 0.2784, b = 0.5490}, -- #8e478c
    ["treachery"] = {r = 0.6863, g = 0.9255, b = 0.9333}  -- #afebee
}


function intermission:load()
    
end

function intermission:createPanel()
    intermission:generateInfernoOrder()
    intermission:registerPallets()


    for l,l1 in pairs(intermission.chosenOrder) do
        print(l1, "Layer ".. l)
    end
    infernoIntermission.panel = nil
    intermission.panel = {
        x = 0,
        y = 0,
        sprite = util.sprites:getSprite("intermission_bg"),
    }

    intermission.diagram = {
        x = love.graphics.getWidth()/2,
        y = love.graphics.getHeight()/2,
        sprite = util.sprites:getSprite("layer1"),
        individualSprites = {}
    }

    for i=1,9 do
        local layerActor = intermission.chosenOrder[i]
        local newSprite = util.sprites:palletSwap(util.sprites:getSprite("layer".. i), util.sprites.pallets.white1, util.sprites.pallets[layerActor.. "Diagram"])

        table.insert(intermission.diagram.individualSprites, newSprite)
    end
end

function intermission:registerPallets()
    util.sprites:registerPallet({"#ffffff"}, "white1")

    util.sprites:registerPallet({"#b8b3a9"}, "limboDiagram")
    util.sprites:registerPallet({"#cd6093"}, "lustDiagram")
    util.sprites:registerPallet({"#78955a"}, "gluttonyDiagram")
    util.sprites:registerPallet({"#f4b41b"}, "greedDiagram")
    util.sprites:registerPallet({"#3978a8"}, "wrathDiagram")
    util.sprites:registerPallet({"#b02c2c"}, "heresyDiagram")
    util.sprites:registerPallet({"#ff7c2c"}, "violenceDiagram")
    util.sprites:registerPallet({"#8e478c"}, "fraudDiagram")
    util.sprites:registerPallet({"#afebee"}, "treacheryDiagram")
end

function intermission:drawUI()
    local scale = getScaleFactor()*5

    love.graphics.draw(intermission.panel.sprite, love.graphics.getWidth() / 2 + (intermission.panel.x * scale), love.graphics.getHeight()/2 + (intermission.panel.y * scale), 0, scale+0.1, scale+0.1, intermission.panel.sprite:getWidth()/2, intermission.panel.sprite:getHeight()/2)
    local obj = intermission.diagram
    for l,l1 in pairs(obj.individualSprites) do
        love.graphics.draw(l1, obj.x+ (intermission.panel.x * scale), obj.y + 20+ (intermission.panel.y * scale), 0, scale,scale, obj.sprite:getWidth()/2, obj.sprite:getHeight()/2)
    end
end

function intermission:generateInfernoOrder()
    intermission.chosenOrder = {}
    local shuffledMid = intermission:shuffle(intermission.shuffleableLayers)

    table.insert(intermission.chosenOrder,"limbo")
    for l,l1 in pairs(shuffledMid) do
        table.insert(intermission.chosenOrder,l1)
    end
    table.insert(intermission.chosenOrder,"treachery")
end

function intermission:shuffle(t)
    local count = #t
    
    for i = count, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end


return intermission