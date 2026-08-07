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

local deltaTimer = 0
function flowerM:update(dt)
    deltaTimer = deltaTimer + dt
    for _, i in pairs(flowerM.flowers) do
        local growthSpeed = dt * 10

        if i.growthStage == "bulb" then
            if i.growth < 10 then
                i.growth = math.min(10, i.growth + growthSpeed)
            else
                i.growthStage = "stem"
            end

        elseif i.growthStage == "stem" then
            if i.growth < 50 then
                i.growth = math.min(50, i.growth + growthSpeed)
            else
                i.growthStage = "bloom"
            end
        elseif i.growthStage == "bloom" then
            if i.growth < 100 then
                i.growth = math.min(100, i.growth + growthSpeed)
            end
        end

        if i.growth > 50 and not i.hasBloomed then
            i.hasBloomed = true

            if util.dialogue.tutorial.fullyComplete == false and util.dialogue.tutorial.flowerBloomed == false then
                util.dialogue.tutorial.flowerBloomed = true
                util.dialogue:initiateDialogue("virgil", "flowerBloomed")
            end

            local faces = {i.data.v1, i.data.v2}
            local cV = i.data.v2 or i.data.v1
            i.sprites = {
                head = util.sprites:getSprite("head-".. i.data.v1),
                stem = util.sprites:getSprite("stem-".. cV),
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
    local stemID = flowerInputs.v1.. "-baby"
    if flowerInputs.v2 ~= nil then
        stemID = flowerInputs.v2.. "-baby"
    end
    local newFlower = {
        x = love.graphics:getWidth()/2,
        y = love.graphics:getHeight()/2,
        data = flowerInputs,
        growthStage = nil,
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
        growth = 0,
        uuid = love.math.random()
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
            table.insert(bloomed, flowerM:cloneFlower(f1))
        end
    end

    return bloomed
end

function flowerM:cloneFlower(oldF)
    local newFlower = {
        x = oldF.x,
        y = oldF.y,
        growthStage = oldF.growthStage,
        growth = oldF.growth,
        hasBloomed = oldF.hasBloomed,

        data = {
            v1 = oldF.data.v1,
            v2 = oldF.data.v2,
            v3 = oldF.data.v3,
            virtueList = oldF.data.virtueList,
            chosenColour = oldF.data.chosenColour
        },

        sprites = {
            head = oldF.sprites.head,
            stem = oldF.sprites.stem,
            face = oldF.sprites.face,
            bulb = oldF.sprites.bulb,
            sideBulb = oldF.sprites.sideBulb
        },


        translation = {
            stem = {
                x = oldF.translation.stem.x,
                y = oldF.translation.stem.y
            },
            face = {
                x = oldF.translation.face.x,
                y = oldF.translation.face.y
            }
        },
        uuid = oldF.uuid
    }

    return newFlower
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


        elseif flower.growthStage == "bulb" or flower.growthStage == nil then
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
    local faceXA = 0
    if extraTrans ~= nil then
        if extraTrans.scale ~=nil then newScaleMult = extraTrans.scale end
        if extraTrans.face ~= nil then
            if extraTrans.face.x ~= nil then faceXA = extraTrans.face.x end
        end
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
                flower.x + flower.translation.face.x + flower.translation.stem.x + faceXA,
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


        elseif flower.growthStage == "bulb" or flower.growthStage == nil  then
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
        flower = flowerM:generateRandomFlower(),
        sprite = util.sprites:getSprite("pot"),
        x = 0,
        y = 0,
        scheduledSeed = nil
    }

    newPot.onClick = function()
        if newPot.flower ~= nil then
            local f = newPot.flower

            if f.growthStage == "bulb" and f.growth >= 10 then
                f.growthStage = "stem"

            elseif f.growthStage == "stem" and f.growth >= 50 then
                f.growthStage = "bloom"
            end

            if  gardenM.cameraStatic == false and cam.roomPos == 0 then
                if newPot.flower.growthStage == nil then
                    if gardenM.currentTool == "wateringCan" then
                        minigameM:startMinigame("fertiliser", newPot)
                    end
                else
                    flowerM:openFlowerInfo(newPot)
                end
            end
        end


        if newPot.scheduledSeed ~= nil then
            if util.dialogue.tutorial.fullyComplete == false and util.dialogue.tutorial.afterPlant == false then
                util.dialogue.tutorial.afterPlant = true
                util.dialogue:initiateDialogue("virgil", "afterPlant")
            end

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

            util.input:markDead(newPot.scheduledSeed)
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
    end


    table.insert(flowerM.pots, newPot)
    util.input:addClickable(newPot,"garden")

    return newPot
end

function flowerM:generateRandomFlower()
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

    flowerData.chosenColour = flowerM.virtues[ math.random( #flowerM.virtues ) ]

    local newFlower = flowerM:generateFlower(flowerData)
    return newFlower
end

function flowerM:drawUI()
    if flowerM.infoUi ~= nil then
        --flowerM.infoUi.titleText:draw()

        for d1,d in ipairs(flowerM.infoUi.vDisplays) do
            love.graphics.draw(d.sprite, d.x, d.y + math.sin(deltaTimer + (d1))*10, d.rot, 6, 6, d.sprite:getWidth()/2, d.sprite:getHeight()/2)
        end

        for m1,m in ipairs(flowerM.infoUi.moveDisplays) do
            if m1 == flowerM.infoUi.selectedMove then
                for t,t1 in ipairs(m.texts) do
                    if flowerM.infoUi.moveDisplays[2] ~= nil then
                        if t1.id == "mDisplayDesc2" then
                            t1.originY = -7
                        end
                    end

                    t1.y = t1.baseY + math.sin(deltaTimer + (m1/2))*10
                    t1:draw()
                end
            end
            
            love.graphics.draw(m.sprite, m.x, m.y + math.sin(deltaTimer + (m1/2))*10, m.rot, 6,6, m.sprite:getWidth()/2, m.sprite:getHeight()/2)
            m.txt.x = m.x
            m.txt.y = m.y + math.sin(deltaTimer + (m1/2))*10

            

            m.txt:draw()
        end
    end
end 

flowerM.infoUi = nil

local flowerGuiSpeed = 0.8
function flowerM:openFlowerInfo(pot)
    battleM:addMoveSet(pot.flower)


    local pV1 = pot.flower.data.v1
    local pV2 = nil
    local pV3 = nil

    if pot.flower.data.v2 ~= pV1 then
        pV2 = pot.flower.data.v2
    end

    if pot.flower.data.v3 ~= pV1 and pot.flower.data.v3 ~= pV2 then
        pV3 = pot.flower.data.v3
    end

    local newUi = {
        titleText = util.text:createText("flowerInfoTitle", pV1, util.sprites.pallets[pV1]),
        vDisplays = {},
        moveDisplays = {},
        selectedMove = 0
    }

    util.time:runDeferred(flowerGuiSpeed, function()
        newUi.returnActor = {
            x = 0,
            y = 0,
            sprite = util.sprites:getSprite("SCREEN-CONSUMER"),
            layer = 99
        }

        newUi.returnActor.onClick = function()
            flowerM:closeFlowerInfo()
        end

        util.input:addClickable(newUi.returnActor,sceneM.activeScene, true) end)

    local vCount = 0
    local mCount = 0
    if pV1 ~= nil then
        vCount = vCount + 1
        mCount = mCount + 1
        newUi.vDisplays[1] = {
            x = love.graphics:getWidth()/2,
            y = -love.graphics:getHeight()/2,
            sprite = util.sprites:getSprite(pV1.. "-icon"),
            rot = 0
        }

        local cPallet = util.sprites.pallets[pV2] or util.sprites.pallets[pV1]
        newUi.moveDisplays[1] = {
            x = -love.graphics:getWidth()/2,
            y = love.graphics:getHeight()/2,
            sprite = util.sprites:getSprite(pot.flower.data.moveSet[1].type.. "_move_button"),
            txt = util.text:createText("moveDisplayText1", pot.flower.data.moveSet[1].name, util.sprites.pallets[pot.flower.data.moveSet[1].type], 70),
            layer = 999,
            scaleX = 0.6,
            scaleY = 0.6,
            texts = {
                [1] = util.text:createText("mDisplayDmg1", pot.flower.data.moveSet[1].damage.. " Damage", util.sprites.pallets[pot.flower.data.moveSet[1].type], 0, true),
                [2] = util.text:createText("mDisplayPierce1", pot.flower.data.moveSet[1].pierce.. " Pierce", cPallet, 0, true)
            }
        }

        newUi.moveDisplays[1].onClick = function()
            flowerM:flowerInfoMove(1)
        end

        
        util.input:addClickable(newUi.moveDisplays[1],"garden",true)
    end
    if pV2 ~= nil then
        vCount = vCount + 1
        newUi.vDisplays[2] = {
            x = love.graphics:getWidth()/2,
            y = -love.graphics:getHeight()/2,
            sprite = util.sprites:getSprite(pV2.. "-icon"),
            rot = 0
        }
    end
    if pV3 ~= nil then
        vCount = vCount + 1
        mCount = mCount + 1

        newUi.vDisplays[3] = {
            x = love.graphics:getWidth()/2,
            y = -love.graphics:getHeight()/2,
            sprite = util.sprites:getSprite(pV3.. "-icon"),
            rot = 0
        }

        newUi.moveDisplays[2] = {
            x = -love.graphics:getWidth()/2,
            
            y = love.graphics:getHeight()/2,
            sprite = util.sprites:getSprite(pot.flower.data.moveSet[2].type.. "_move_button"),
            txt = util.text:createText("moveDisplayText1", pot.flower.data.moveSet[2].name, util.sprites.pallets[pot.flower.data.moveSet[2].type], 70),
            scaleX = 0.6,
            scaleY = 0.6,
            layer = 999,
            texts = {
                [1] = util.text:createText("mDisplayDmg2", pot.flower.data.moveSet[2].damage.. " Damage", util.sprites.pallets[pot.flower.data.moveSet[2].type], 0, true),
                [2] = util.text:createText("mDisplayPierce2", pot.flower.data.moveSet[2].pierce.. " Pierce", util.sprites.pallets[pot.flower.data.moveSet[2].type], 0, true),
                [3] = util.text:createText("mDisplayDesc2", "This is a placeholder description for a secondary ability", util.sprites.pallets.dialogueText, 250, false, true)
            }
        }

        newUi.moveDisplays[2].onClick = function()
            flowerM:flowerInfoMove(2)
        end

        
        util.input:addClickable(newUi.moveDisplays[2],"garden",true)
    end

    newUi.moveDisplays[1].txt.scaleX, newUi.moveDisplays[1].txt.scaleY = 3, 3

    for t,t1 in ipairs(newUi.moveDisplays[1].texts) do
        t1.scaleX, t1.scaleY = 3,3
        t1.x = -love.graphics:getWidth()/2
        t1.y = love.graphics:getHeight()/2
    end

    if newUi.moveDisplays[2] ~= nil then
        newUi.moveDisplays[2].txt.scaleX, newUi.moveDisplays[2].txt.scaleY = 3, 3

        for t,t1 in ipairs(newUi.moveDisplays[2].texts) do
            t1.scaleX, t1.scaleY = 3,3
            t1.x = -love.graphics:getWidth()/2
            t1.y = love.graphics:getHeight()/2
        end
    end

    local dist = 120

    if vCount == 1 then
        util.tween:tweenProperty(newUi.vDisplays[1], "y", love.graphics:getHeight()/5, flowerGuiSpeed, "vDisplay1Y", "out")
    elseif vCount == 2 then
        util.tween:tweenProperty(newUi.vDisplays[1], "x", love.graphics:getWidth()/2 - dist, flowerGuiSpeed, "vDisplay1X", "out")
        util.tween:tweenProperty(newUi.vDisplays[1], "y", love.graphics:getHeight()/5, flowerGuiSpeed, "vDisplay1Y", "out")
        util.tween:tweenProperty(newUi.vDisplays[1], "rot", math.rad(-4), flowerGuiSpeed, "vDisplay1Rot", "out")

        util.tween:tweenProperty(newUi.vDisplays[2], "x", love.graphics:getWidth()/2 + dist, flowerGuiSpeed, "vDisplay2X", "out")
        util.tween:tweenProperty(newUi.vDisplays[2], "y", love.graphics:getHeight()/5, flowerGuiSpeed, "vDisplay2Y", "out")
        util.tween:tweenProperty(newUi.vDisplays[2], "rot", math.rad(4), flowerGuiSpeed, "vDisplay2Rot", "out")
    else
        util.tween:tweenProperty(newUi.vDisplays[1], "x", love.graphics:getWidth()/2 - dist*1.5, flowerGuiSpeed, "vDisplay1X", "out")
        util.tween:tweenProperty(newUi.vDisplays[1], "y", love.graphics:getHeight()/5, flowerGuiSpeed, "vDisplay1Y", "out")
        util.tween:tweenProperty(newUi.vDisplays[1], "rot", math.rad(-7), flowerGuiSpeed, "vDisplay1Rot", "out")

        util.tween:tweenProperty(newUi.vDisplays[2], "x", love.graphics:getWidth()/2, flowerGuiSpeed, "vDisplay2X", "out")
        util.tween:tweenProperty(newUi.vDisplays[2], "y", love.graphics:getHeight()/5 - 30, flowerGuiSpeed, "vDisplay2Y", "out")
        

        util.tween:tweenProperty(newUi.vDisplays[3], "x", love.graphics:getWidth()/2 + dist*1.5, flowerGuiSpeed, "vDisplay3X", "out")
        util.tween:tweenProperty(newUi.vDisplays[3], "y", love.graphics:getHeight()/5, flowerGuiSpeed, "vDisplay3Y", "out")
        util.tween:tweenProperty(newUi.vDisplays[3], "rot", math.rad(7), flowerGuiSpeed, "vDisplay3Rot", "out")
    end

    if mCount == 1 then
        util.tween:tweenProperty(newUi.moveDisplays[1], "x", love.graphics:getWidth()/4, flowerGuiSpeed, "moveDisplay1X", "out")
    elseif mCount == 2 then
        util.tween:tweenProperty(newUi.moveDisplays[1], "x", love.graphics:getWidth()/4, flowerGuiSpeed, "moveDisplay1X", "out")
        util.tween:tweenProperty(newUi.moveDisplays[1], "y", love.graphics:getHeight()/2 - 70, flowerGuiSpeed, "moveDisplay1Y", "out")

        util.tween:tweenProperty(newUi.moveDisplays[2], "x", love.graphics:getWidth()/4, flowerGuiSpeed, "moveDisplay2X", "out")
        util.tween:tweenProperty(newUi.moveDisplays[2], "y", love.graphics:getHeight()/2 + 70, flowerGuiSpeed, "moveDisplay2Y", "out")
    end

    newUi.titleText.x = love.graphics:getWidth()/2
    newUi.titleText.y = -love.graphics:getHeight()/2
    newUi.titleText.scaleX, newUi.titleText.scaleY = 4, 4

    util.tween:tweenProperty(newUi.titleText, "y", love.graphics:getHeight()/4 , 1.5, "infoTitleTextY", "out")

    flowerM.infoUi = newUi

    util.tween:tweenProperty(cam, "zoom", 10.5, flowerGuiSpeed, "CamZoom", "out")
    util.tween:tweenProperty(cam, "projX", pot.x, flowerGuiSpeed, "camTweenX", "out")
    util.tween:tweenProperty(cam, "yAddition", pot.y - 10, flowerGuiSpeed, "CamMoveY", "out")
    util.tween:tweenProperty(altarM,"vignetteZoomMult" , 0.9, flowerGuiSpeed, "vignetteZoom", "out")

    gardenM.cameraStatic = true
end

function flowerM:closeFlowerInfo()
    flowerM.infoUi.selectedMove = 0
    util.tween:tweenProperty(cam, "zoom", 5, flowerGuiSpeed, "CamZoom", "out")
    util.tween:tweenProperty(cam, "projX", 0, flowerGuiSpeed, "CamMoveX", "out")
    util.tween:tweenProperty(cam, "yAddition", 0, flowerGuiSpeed, "CamMoveY", "out")

    util.tween:tweenProperty(altarM,"vignetteZoomMult" , 4, flowerGuiSpeed, "vignetteZoom", "out")

    if flowerM.infoUi.moveDisplays[1] ~= nil then
        util.tween:tweenProperty(flowerM.infoUi.moveDisplays[1],"x" , -love.graphics:getWidth()/2, flowerGuiSpeed, "moveDisplay1X", "out")
        util.tween:tweenProperty(flowerM.infoUi.moveDisplays[1],"y" , love.graphics:getHeight()/2, flowerGuiSpeed, "moveDisplay1Y", "out")
    end

    if flowerM.infoUi.moveDisplays[2] ~= nil then
        util.tween:tweenProperty(flowerM.infoUi.moveDisplays[2],"x" , -love.graphics:getWidth()/2, flowerGuiSpeed, "moveDisplay2X", "out")
        util.tween:tweenProperty(flowerM.infoUi.moveDisplays[2],"y" , love.graphics:getHeight()/2, flowerGuiSpeed, "moveDisplay1Y", "out")
    end

    if flowerM.infoUi.vDisplays[1] ~= nil then
        util.tween:tweenProperty(flowerM.infoUi.vDisplays[1],"x" , love.graphics:getWidth()/2, flowerGuiSpeed, "vDisplay1X", "out")
        util.tween:tweenProperty(flowerM.infoUi.vDisplays[1],"y" , -love.graphics:getHeight()/2, flowerGuiSpeed, "vDisplay1Y", "out")
    end
    if flowerM.infoUi.vDisplays[2] ~= nil then
        util.tween:tweenProperty(flowerM.infoUi.vDisplays[2],"x" , love.graphics:getWidth()/2, flowerGuiSpeed, "vDisplay2X", "out")
        util.tween:tweenProperty(flowerM.infoUi.vDisplays[2],"y" , -love.graphics:getHeight()/2, flowerGuiSpeed, "vDisplay2Y", "out")
    end
    if flowerM.infoUi.vDisplays[3] ~= nil then
        util.tween:tweenProperty(flowerM.infoUi.vDisplays[3],"x" , love.graphics:getWidth()/2, flowerGuiSpeed, "vDisplay3X", "out")
        util.tween:tweenProperty(flowerM.infoUi.vDisplays[3],"y" , -love.graphics:getHeight()/2, flowerGuiSpeed, "vDisplay3Y", "out")
    end



    util.time:runDeferred(flowerGuiSpeed, function()
        gardenM.cameraStatic = false
        flowerM.infoUi = nil
    end)

    util.input:markDead(flowerM.infoUi.returnActor)

    
end

function flowerM:flowerInfoMove(idx)
    if flowerM.infoUi.selectedMove == idx then idx = 0 end
    flowerM.infoUi.selectedMove = idx

    for m,m1 in ipairs(flowerM.infoUi.moveDisplays) do
        if m == idx then
            util.tween:tweenProperty(m1,"x" , love.graphics:getWidth()/7, 0.2, "moveDisplay"..m.."X", "out")

            for t,t1 in ipairs(m1.texts) do
                t1.baseY = m1.y 
                t1.x = m1.x - 70

                util.tween:tweenProperty(t1,"x" , love.graphics:getWidth()/4, 0.3, "moveDisplayTxt"..t.."X"..m, "out")
                util.tween:tweenProperty(t1,"baseY" , m1.y + ((t-1)*50), 0.3, "moveDisplayTxt"..t.."Y"..m, "out")

            end
        else
            util.tween:tweenProperty(m1,"x" , love.graphics:getWidth()/4, 0.2, "moveDisplay"..m.."X", "out")

            for t,t1 in ipairs(m1.texts) do
                util.tween:tweenProperty(t1,"x" , -love.graphics:getWidth()/2, 0.2, "moveDisplayTxt"..t.."X"..m, "out")
            end
        end
    end
end

return flowerM