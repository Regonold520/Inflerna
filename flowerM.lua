local flowerM = {}

function Color(hex, value)
	return {tonumber(string.sub(hex, 2, 3), 16)/256, tonumber(string.sub(hex, 4, 5), 16)/256, tonumber(string.sub(hex, 6, 7), 16)/256, 1 or 1}
end

flowerM.flowers = {}
flowerM.stemData = {}
flowerM.faceTranslations = {}
flowerM.stemBulbs = {}

flowerM.virtues = {"chastity", "charity", "kindness", "temperance", "diligence", "patience", "humility"}

flowerM.pots = {}

function flowerM:load()
    flowerM:registerFlowerData()

    for py=0, 2 do
        for px=0, 5 do
            local peakPot = flowerM:createPot()

            peakPot.x = -75 + (px*30)
            peakPot.y = -15 + (py*30)
        
            
        end
    end

    
end

function flowerM:update(dt)
    for _, i in pairs(flowerM.flowers) do
        local growthSpeed = dt * 10

        if i.growthStage == "bulb" then
            if i.growth < 10 then
                i.growth = math.min(10, i.growth + growthSpeed)
            end

        elseif i.growthStage == "stem" then
            if i.growth < 50 then
                i.growth = math.min(50, i.growth + growthSpeed)
            end

        elseif i.growthStage == "bloom" then
            if i.growth < 100 then
                i.growth = math.min(100, i.growth + growthSpeed)
            end
        end

        if i.growth > 50 and not i.hasBloomed then
            i.hasBloomed = true

            local faces = {i.data.v1, i.data.v2}
            i.sprites = {
                head = util.sprites:getSprite("head-".. i.data.v1),
                stem = util.sprites:getSprite("stem-".. i.data.v2 or i.data.v1),
                face = util.sprites:getSprite("face-"..faces[ math.random( #faces ) ]),
                sideBulb = util.sprites:getSprite("side_bulb"),
                bulb = util.sprites:getSprite("bulb")
            }

            i.sprites.head = util.sprites:palletSwap(i.sprites.head, util.sprites.pallets.flowergray, util.sprites.pallets[i.data.chosenColour])
            local colour = i.data.v3 or i.data.v1
            i.sprites.sideBulb = util.sprites:palletSwap(i.sprites.sideBulb, util.sprites.pallets.flowergray, util.sprites.pallets[colour])
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

    flowerM:registerStemBulb("patience", 5, -11)
    flowerM:registerStemBulb("humility", -5,-10)

    flowerM:registerStemBulb("temperance", 8,-10)
    flowerM:registerStemBulb("temperance", -8,-10)

    flowerM:registerStemBulb("charity", 12,-10)
    flowerM:registerStemBulb("charity", -12,-10)
    flowerM:registerStemBulb("charity", 7,-10)
    flowerM:registerStemBulb("charity", -7,-10)

    flowerM:registerFaceTranslation("kindness",0, 2)
    flowerM:registerFaceTranslation("temperance",0, -1)
    flowerM:registerFaceTranslation("patience",0, -2)
    flowerM:registerFaceTranslation("humility",0, 1)

end

function flowerM:registerStemBulb(id, x, y)
    if flowerM.stemBulbs[id] == nil then
        flowerM.stemBulbs[id] = {}
    end

    local newBulbData = {
        x = x,
        y = y
    }

    table.insert(flowerM.stemBulbs[id], newBulbData)
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
        growthStage = "bulb",
        hasBloomed = false,
        sprites = {
            head = util.sprites:getSprite("head-".. flowerInputs.v1.. "-baby"),
            bulb = util.sprites:getSprite("bulb"),
            sideBulb = util.sprites:getSprite("side_bulb"),
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
    newFlower.sprites.bulb = util.sprites:palletSwap(newFlower.sprites.bulb, util.sprites.pallets.flowergray, util.sprites.pallets[flowerInputs.chosenColour])
    newFlower.sprites.face = util.sprites:palletSwap(newFlower.sprites.face, util.sprites.pallets.flowergray, util.sprites.pallets[flowerInputs.chosenColour])

    table.insert(flowerM.flowers, newFlower)

    return newFlower
end

function flowerM:getBloomedFlowers()
    local bloomed = {}

    for _, f1 in pairs(flowerM.flowers) do
        if f1.hasBloomed then
            local newFlower = {
                x = f1.x,
                y = f1.y,
                growthStage = f1.growthStage,
                growth = f1.growth,
                hasBloomed = f1.hasBloomed,

                data = {
                    v1 = f1.data.v1,
                    v2 = f1.data.v2,
                    v3 = f1.data.v3,
                    virtueList = f1.data.virtueList,
                    chosenColour = f1.data.chosenColour
                },

                sprites = {
                    head = f1.sprites.head,
                    stem = f1.sprites.stem,
                    face = f1.sprites.face,
                    bulb = f1.sprites.bulb,
                    sideBulb = f1.sprites.sideBulb
                },


                translation = {
                    stem = {
                        x = f1.translation.stem.x,
                        y = f1.translation.stem.y
                    },
                    face = {
                        x = f1.translation.face.x,
                        y = f1.translation.face.y
                    }
                }
            }

            table.insert(bloomed, newFlower)
        end
    end

    return bloomed
end

function flowerM:generateSeed(flowerInputs)
    local newSeed = {
        x = 0,
        y = 0,
        data = flowerInputs,
        sprite = util.sprites:getSprite("blessed_seed"),
        clicked = false
    }

    if flowerInputs.chosenColour ~= nil then
        newSeed.sprite = util.sprites:palletSwap(newSeed.sprite, util.sprites.pallets.flowergray, util.sprites.pallets[flowerInputs.chosenColour])
    end

    return newSeed
end

function flowerM:draw()
    flowerM:drawPots()
end

function flowerM:drawIndividualFlowerPot(flower, pot)
    pot = pot or {x=0, y=0, sprite=util.sprites:getSprite("pot")}

    if flower ~= nil then
        local scaleM = math.min(1, math.max(0.5, flower.growth / 50))

        love.graphics.draw(
            flower.sprites.stem,
            pot.x,
            pot.y - 11 + pot.sprite:getHeight()/2,
            0,
            scaleM,
            scaleM,
            flower.sprites.stem:getWidth()/2,
            flower.sprites.stem:getHeight()
        )

        
        
        

        if flower.growth > 10 then
            love.graphics.draw(
                flower.sprites.head,
                pot.x + flower.translation.stem.x,
                pot.y + flower.translation.stem.y - 11 + pot.sprite:getHeight()/2,
                0,
                scaleM,
                scaleM,
                flower.sprites.head:getWidth()/2,
                flower.sprites.stem:getHeight()*2 - 3
            )


            love.graphics.draw(
                flower.sprites.face,
                pot.x + flower.translation.face.x + flower.translation.stem.x,
                pot.y + flower.translation.face.y + flower.translation.stem.y - 11 + pot.sprite:getHeight()/2,
                0,
                scaleM,
                scaleM,
                flower.sprites.face:getWidth()/2,
                (flower.sprites.stem:getHeight()*2 - 3) - flower.sprites.head:getHeight()/2 + flower.sprites.face:getHeight()/2
            )

            if flower.growth > 50 and flower.growthStage == "bloom" then
            local chosenV = flower.data.v2 or flower.data.v1
            if flowerM.stemBulbs[chosenV] ~= nil then
                for b,b1 in pairs(flowerM.stemBulbs[chosenV]) do
                    love.graphics.draw(
                        flower.sprites.sideBulb,
                        pot.x + b1.x,
                        pot.y - 11 + pot.sprite:getHeight()/2  + b1.y,
                        0,
                        scaleM,
                        scaleM,
                        flower.sprites.sideBulb:getWidth()/2,
                        flower.sprites.sideBulb:getHeight()
                    )
                end
            end

        end 


        elseif flower.growthStage == "bulb" then
            love.graphics.draw(
                flower.sprites.bulb,
                pot.x + flower.translation.stem.x,
                pot.y + flower.translation.stem.y +1.5,
                0,
                scaleM,
                scaleM,
                flower.sprites.bulb:getWidth()/2,
                flower.sprites.stem:getHeight()*2 - 3
            )
        end
    end
end

function flowerM:drawIndividualFlower(flower,extraTrans)
    local newScaleMult = 1
    if extraTrans ~= nil then
        if extraTrans.scale ~=nil then newScaleMult = extraTrans.scale end

    end


    if flower ~= nil then
        local scaleM = (math.min(1, math.max(0.5, flower.growth / 50)) * newScaleMult)

        love.graphics.draw(
            flower.sprites.stem,
            flower.x,
            flower.y,
            0,
            scaleM,
            scaleM,
            flower.sprites.stem:getWidth()/2,
            flower.sprites.stem:getHeight()
        )

        
        
        

        if flower.growth > 10 then
            love.graphics.draw(
                flower.sprites.head,
                flower.x + flower.translation.stem.x,
                flower.y + flower.translation.stem.y,
                0,
                scaleM,
                scaleM,
                flower.sprites.head:getWidth()/2,
                flower.sprites.stem:getHeight()*2 - 3
            )


            love.graphics.draw(
                flower.sprites.face,
                flower.x + flower.translation.face.x + flower.translation.stem.x,
                flower.y + flower.translation.face.y + flower.translation.stem.y,
                0,
                scaleM,
                scaleM,
                flower.sprites.face:getWidth()/2,
                (flower.sprites.stem:getHeight()*2 - 3) - flower.sprites.head:getHeight()/2 + flower.sprites.face:getHeight()/2
            )

            if flower.growth > 50 and flower.growthStage == "bloom" then
            local chosenV = flower.data.v2 or flower.data.v1
            if flowerM.stemBulbs[chosenV] ~= nil then
                for b,b1 in pairs(flowerM.stemBulbs[chosenV]) do
                    love.graphics.draw(
                        flower.sprites.sideBulb,
                        flower.x + (b1.x*scaleM),
                        flower.y + (b1.y*scaleM),
                        0,
                        scaleM,
                        scaleM,
                        flower.sprites.sideBulb:getWidth()/2,
                        flower.sprites.sideBulb:getHeight()
                    )
                end
            end

        end 


        elseif flower.growthStage == "bulb" then
            love.graphics.draw(
                flower.sprites.bulb,
                flower.x + flower.translation.stem.x,
                flower.y + flower.translation.stem.y +1.5,
                0,
                scaleM,
                scaleM,
                flower.sprites.bulb:getWidth()/2,
                flower.sprites.stem:getHeight()*2 - 3
            )
        end
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

        flowerM:drawIndividualFlowerPot(pot.flower, pot)

    end
end


function flowerM:createPot()
    local newPot = {
        flower = nil,
        sprite = util.sprites:getSprite("pot"),
        x = 0,
        y = 0,
        scheduledSeed = nil
    }

    newPot.onClick = function()
        if newPot.flower ~= nil and gardenM.currentTool == "wateringCan" then
            local f = newPot.flower

            if f.growthStage == "bulb" and f.growth >= 10 then
                f.growthStage = "stem"

            elseif f.growthStage == "stem" and f.growth >= 50 then
                f.growthStage = "bloom"
            end
        end


        if newPot.scheduledSeed ~= nil then
            local x1 = newPot.scheduledSeed.data.v1 
            local y1 = newPot.scheduledSeed.data.v2 or newPot.scheduledSeed.data.v1
            local z1 = newPot.scheduledSeed.data.v3 or newPot.scheduledSeed.data.v1
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

            input:markDead(newPot.scheduledSeed)
            altarM.occupiedSeed = nil

            local count = 1
            for s,s1 in pairs(altarM.pendingSeeds) do
                if s1 == newPot.scheduledSeed then
                    table.remove(altarM.pendingSeeds, count)
                end
                count = count + 1
            end

            newPot.scheduledSeed = nil
        end
    end

    newPot.addFlower = function(self, flower)
        self.flower = flower
        print(self.flower.data.v1)
    end


    table.insert(flowerM.pots, newPot)
    input:addClickable(newPot,"garden")

    return newPot
end

return flowerM