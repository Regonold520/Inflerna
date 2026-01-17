local flowerM = {}

function Color(hex, value)
	return {tonumber(string.sub(hex, 2, 3), 16)/256, tonumber(string.sub(hex, 4, 5), 16)/256, tonumber(string.sub(hex, 6, 7), 16)/256, 1 or 1}
end

flowerM.flowers = {}
flowerM.stemData = {}
flowerM.faceTranslations = {}

flowerM.virtues = {"chastity", "charity", "kindness", "temperance", "diligence", "patience", "humility"}

flowerM.pots = {}

function flowerM:load()
    flowerM:registerFlowerData()

    for px=0, 5 do
        for py=0, 2 do
            local peakPot = flowerM:createPot()

            peakPot.x = -75 + (px*30)
            peakPot.y = -15 + (py*30)
        
            
        end
    end

    
end

function flowerM:update(dt)
    for _,i in pairs(flowerM.flowers) do
        if i.growth < 50 then
            i.growth = i.growth + dt * 10
        end
        if i.growth >= 50  and i.growth < 60 then
            local faces = {i.data.v1, i.data.v2}
            i.sprites = {
                head = util.sprites:getSprite("head-".. i.data.v1),
                stem = util.sprites:getSprite("stem-".. i.data.v2 or i.data.v1),
                face = util.sprites:getSprite("face-"..faces[ math.random( #faces ) ])
            }

            i.sprites.head = util.sprites:palletSwap(i.sprites.head, util.sprites.pallets.flowergray, util.sprites.pallets[i.data.chosenColour])
            i.sprites.face = util.sprites:palletSwap(i.sprites.face, util.sprites.pallets.flowergray, util.sprites.pallets[i.data.chosenColour])

            if flowerM.stemData[i.data.v2 or i.data.v1] ~= nil then

                local faceTrans = flowerM.faceTranslations[i.data.v1] or { translation = { x = 0, y = 0 } }

                i.translation = {
                    stem = {
                        x = flowerM.stemData[i.data.v2 or i.data.v1].translation.x,
                        y = flowerM.stemData[i.data.v2 or i.data.v1].translation.y
                    },
                    face = {
                        x = faceTrans.translation.x,
                        y = faceTrans.translation.y
                    }
                }

            end

            i.growth = 100
        end


    end
end

function flowerM:registerFlowerData()
    util.sprites:registerPallet({
        "#ffcbcb",
        "#ffb9b9",
        "#f5a3ab",
        "#e5949d",
        "#774e50"
    }, "charity")

    util.sprites:registerPallet({
        "#ff9831",
        "#f58f29",
        "#ee7a18",
        "#e55d15",
        "#742d08"
    }, "diligence")

    util.sprites:registerPallet({
        "#f4fcfb",
        "#e4f2f0",
        "#c8dbda",
        "#b1c4c7",
        "#61676d"
    }, "chastity")

    util.sprites:registerPallet({
        "#d4eb56",
        "#c7de4d",
        "#b2d138",
        "#9cbd2d",
        "#566a13"
    }, "kindness")

    util.sprites:registerPallet({
        "#c075b7",
        "#b66dad",
        "#a95ba3",
        "#954d95",
        "#673467"
    }, "patience")

    util.sprites:registerPallet({
        "#adf9fc",
        "#9deff2",
        "#83e5eb",
        "#7cd2e1",
        "#3b6b74"
    }, "temperance")

    util.sprites:registerPallet({
        "#f5b176",
        "#eeaa6e",
        "#de9252",
        "#db7e4c",
        "#844727"
    }, "humility")

    flowerM:registerStemTranslation("humility",2)
    flowerM:registerStemTranslation("charity",0, 1)
    flowerM:registerStemTranslation("chastity",0,-2)
    flowerM:registerStemTranslation("temperance",0,0)
    flowerM:registerStemTranslation("patience",-4,1)
    flowerM:registerStemTranslation("diligence",0,-3)
    flowerM:registerStemTranslation("kindness",0,-3)

    flowerM:registerStemTranslation("temperance-baby",0,3)
    flowerM:registerStemTranslation("chastity-baby",0,0)
    flowerM:registerStemTranslation("diligence-baby",0,0)
    flowerM:registerStemTranslation("kindness-baby",0,1)
    flowerM:registerStemTranslation("charity-baby",0,3)
    flowerM:registerStemTranslation("patience-baby",-2,0)
    flowerM:registerStemTranslation("humility-baby",1,-1)

    flowerM:registerFaceTranslation("kindness",0, 2)
    flowerM:registerFaceTranslation("temperance",0, -1)
    flowerM:registerFaceTranslation("patience",0, -2)
    flowerM:registerFaceTranslation("humility",0, 1)

end

function flowerM:registerStemTranslation(id,x,y)
    x = x or 0
    y = y or 0

    local entry = {
        translation = {
            x=x,
            y=y
        }
    }

    flowerM.stemData[id] = entry
end

function flowerM:registerFaceTranslation(id,x,y)
    x = x or 0
    y = y or 0

    local entry = {
        translation = {
            x=x,
            y=y
        }
    }

    flowerM.faceTranslations[id] = entry
end

function flowerM:generateFlower(flowerInputs)
    local stemID = flowerInputs.v2.. "-baby" or flowerInputs.v1.. "-baby"
    local newFlower = {
        x = love.graphics:getWidth()/2,
        y = love.graphics:getHeight()/2,
        data = flowerInputs,
        sprites = {
            head = util.sprites:getSprite("head-".. flowerInputs.v1.. "-baby"),
            stem = util.sprites:getSprite("stem-".. stemID),
            face = util.sprites:getSprite("face-baby")
        },
        translation = {
            stem = {
                x = 0,
                y = 0
            },
            face = {
                x = 0,
                y = 0
            }
        },
        growth = 0
    }

    if flowerM.stemData[stemID] ~= nil then
        newFlower.translation = {
            stem = {
                x = flowerM.stemData[stemID].translation.x,
                y = flowerM.stemData[stemID].translation.y
            },
            face = {
                x = 0,
                y = 0
            }
        }
    end
    newFlower.sprites.head = util.sprites:palletSwap(newFlower.sprites.head, util.sprites.pallets.flowergray, util.sprites.pallets[flowerInputs.chosenColour])
    newFlower.sprites.face = util.sprites:palletSwap(newFlower.sprites.face, util.sprites.pallets.flowergray, util.sprites.pallets[flowerInputs.chosenColour])

    table.insert(flowerM.flowers, newFlower)

    return newFlower
end

function flowerM:draw()
    flowerM:drawPots()
end

function flowerM:drawPotFlowers()
    for _, flower in pairs(flowerM.flowers) do
        
    end
end

function flowerM:drawPots()
    for _, pot in pairs(flowerM.pots) do
        love.graphics.draw(
            pot.sprite,
            pot.x,
            pot.y,
            0,
            1,
            1,
            pot.sprite:getWidth()/2,
            pot.sprite:getHeight()/2
        )

        if pot.flower ~= nil then
            local scaleM = math.min(1, math.max(0.5, pot.flower.growth / 50))

            love.graphics.draw(
                pot.flower.sprites.stem,
                pot.x,
                pot.y - 11 + pot.sprite:getHeight()/2,
                0,
                scaleM,
                scaleM,
                pot.flower.sprites.stem:getWidth()/2,
                pot.flower.sprites.stem:getHeight()
            )
            
            

            if pot.flower.growth > 10 then
                love.graphics.draw(
                    pot.flower.sprites.head,
                    pot.x + pot.flower.translation.stem.x,
                    pot.y + pot.flower.translation.stem.y - 11 + pot.sprite:getHeight()/2,
                    0,
                    scaleM,
                    scaleM,
                    pot.flower.sprites.head:getWidth()/2,
                    pot.flower.sprites.stem:getHeight()*2 - 3
                )


                love.graphics.draw(
                    pot.flower.sprites.face,
                    pot.x + pot.flower.translation.face.x + pot.flower.translation.stem.x,
                    pot.y + pot.flower.translation.face.y + pot.flower.translation.stem.y - 11 + pot.sprite:getHeight()/2,
                    0,
                    scaleM,
                    scaleM,
                    pot.flower.sprites.face:getWidth()/2,
                    (pot.flower.sprites.stem:getHeight()*2 - 3) - pot.flower.sprites.head:getHeight()/2 + pot.flower.sprites.face:getHeight()/2
                )


            end
        end
    end
end


function flowerM:createPot()
    local newPot = {
        flower = nil,
        sprite = util.sprites:getSprite("pot"),
        x = 0,
        y = 0
    }

    newPot.onClick = function()
        local x1 = flowerM.virtues[ math.random( #flowerM.virtues ) ]
        local y1 = flowerM.virtues[ math.random( #flowerM.virtues ) ]
        local z1 = flowerM.virtues[ math.random( #flowerM.virtues ) ]
        local flowerData = {
            v1 = x1,
            v2 = y1,
            v3 = z1,
            virtueList = {x1,y1,z1},
            chosenColour = nil
        }

        flowerData.chosenColour = flowerData.virtueList[ math.random( #flowerData.virtueList ) ]

        local newFlower = flowerM:generateFlower(flowerData)
        newPot:addFlower(newFlower)
    end

    newPot.addFlower = function(self, flower)
        self.flower = flower
        print(self.flower.data.v1)
    end


    table.insert(flowerM.pots, newPot)
    input:addClickable(newPot)

    return newPot
end

return flowerM