local battleM = {}

battleM.currentBattle = nil

battleM.moveButtons = {}
battleM.bullets = {}

local playerSpeed = 2

function battleM:load()
end

function battleM:update(dt)
    if battleM.currentBattle ~= nil then
        if battleM.currentBattle.phase == "enemy" then

            for e,e1 in pairs(battleM.currentBattle.enemies) do
                e1:update(dt)
            end

            local moveVec = {x=0,y=0}
            if love.keyboard.isDown("a") then
                moveVec.x = -playerSpeed end
            if love.keyboard.isDown("d") then
                moveVec.x = playerSpeed  end
            if love.keyboard.isDown("s") then
                moveVec.y = playerSpeed  end
            if love.keyboard.isDown("w") then
                moveVec.y = -playerSpeed end
            
            if moveVec.x < 0 then playerM.player.scaleX = -1 elseif moveVec.x > 0 then playerM.player.scaleX = 1 end

            playerM.player.x = clamp(battleM.currentBattle.playerReturn.x - 10, playerM.player.x + moveVec.x, battleM.currentBattle.playerReturn.x + 230)
            playerM.player.y = clamp(battleM.currentBattle.playerReturn.y - 16, playerM.player.y + moveVec.y, battleM.currentBattle.playerReturn.y + 34)
        end

        for e,e1 in pairs(battleM.currentBattle.enemies) do
            if e1.healthBar ~= nil then
                e1.healthBar.x = battleM.currentBattle.enemyReturns[e].x
                e1.healthBar.y = battleM.currentBattle.enemyReturns[e].y - 33
            end
        end
    end

    for f,f1 in pairs(playerM.currentParty) do
        f1.healthBar.x = f1.x
        f1.healthBar.y = f1.y - 33
    end

    
end

function battleM:draw()
    for b,b1 in ipairs(battleM.bullets) do
        util.sprites:drawObject(b1)
    end

    for b,b1 in ipairs(battleM.moveButtons) do
        if battleM.currentBattle ~= nil then
            if battleM.currentBattle.party[b1.flowerIdx] ~= nil then
                if battleM.currentBattle.party[b1.flowerIdx].data.moveSet[b] ~= nil then
                    util.sprites:drawObject(b1)
                    b1.label:draw()
                end
            end
        end
    end

    for _, flower in pairs(playerM.currentParty) do
        local hpPercent = flower.health / flower.maxHealth
        battleM:drawHealthBar(flower.healthBar, hpPercent)
    end

    if battleM.currentBattle ~= nil then
        for e,e1 in pairs(battleM.currentBattle.enemies) do
            if e1.healthBar ~= nil then
                local hpPercent = e1.health / e1.maxHealth
                battleM:drawHealthBar(e1.healthBar, hpPercent)
            end
        end
    end
end

function battleM:genMoveButtons()
    battleM.moveButtons = {}

    for i=1,2 do
        local txt = util.text:createText("MoveButton"..i, "test"..i, util.sprites.pallets.temperance)
        txt.x = playerM.player.x - 150
        txt.y = 0
        txt.baseScale = 0.5

        txt.boundX = util.sprites:getSprite("kindness_move_button"):getWidth() / 1.3

        local moveButton = {
            x=playerM.player.x - 150,
            y=0,
            sprite = util.sprites:getSprite("kindness_move_button"),
            flowerIdx = 1,
            buttonID = i,
            label = txt
        }
        
        moveButton.onClick = function()
            if battleM.currentBattle ~= nil then
                if battleM.currentBattle.phase == "player" then
                    if battleM.currentBattle.bulletAnim == false then
                        local f = battleM.currentBattle.party[moveButton.flowerIdx]
                        local newBullet = {
                            x = f.x,
                            y = f.y,
                            sprite = util.sprites:getSprite("bullet")
                        }

                        table.insert(battleM.bullets, newBullet)

                        battleM.currentBattle.bulletAnim = true

                        util.tween:tweenProperty(newBullet, "x", battleM.currentBattle.enemies[1].x, 0.2, "BulletX".. #battleM.bullets, "out")
                        util.tween:tweenProperty(newBullet, "y", battleM.currentBattle.enemies[1].y - battleM.currentBattle.enemies[1].sprite:getHeight()/2, 0.2, "BulletY".. #battleM.bullets, "out")

                        util.tween:tweenProperty(cam, "x", battleM.currentBattle.playerCam.x + 70, 0.5, "CamMoveX", "out")
                        util.tween:tweenProperty(cam, "zoom", battleM.currentBattle.playerCam.zoom + 1, 0.5, "CamMoveZoom", "in")
                        util.tween:tweenProperty(cam, "rot", math.rad(-700), 0.5, "CamMoveRot", "in")
                        util.time:runDeferred(0.3, function()
                            if battleM.currentBattle ~= nil then
                                battleM.currentBattle.enemies[1].hit(battleM.currentBattle.party[moveButton.flowerIdx].data.moveSet[moveButton.buttonID].damage,
                                    battleM.currentBattle.party[moveButton.flowerIdx].data.moveSet[moveButton.buttonID].pierce)
                            if #battleM.currentBattle.enemies > 0 then
                                    util.tween:tweenProperty(cam, "x", battleM.currentBattle.playerCam.x, 0.5, "CamMoveX", "out")
                                    util.tween:tweenProperty(cam, "zoom", battleM.currentBattle.playerCam.zoom, 0.5, "CamMoveZoom", "out")
                                    
                            end
                            cam.shake(love.math.random(-600,600))
                            end
                        end)

                        util.time:runDeferred(0.7, function()
                            if #battleM.currentBattle.enemies > 0 then
                                if battleM.currentBattle.party[moveButton.flowerIdx].data.moveSet[moveButton.buttonID] ~= nil then
                                    if moveButton.flowerIdx < #battleM.currentBattle.party then
                                        battleM:moveMoveButtons(moveButton.flowerIdx + 1)
                                    else
                                        battleM:enemyPhase()
                                    end
                                end
                            end
                        end
                        )
                    end
                end
            end
        end

        util.input:addClickable(moveButton,"inferno")

        battleM.moveButtons[i] = moveButton
    end
end

function battleM:resetAfterKill(enemy)
    if battleM.currentBattle == nil then return end

    local lastEnemyX = battleM.currentBattle.enemies[1].x
    
    table.remove(battleM.currentBattle.enemies, 1)

    if #battleM.currentBattle.enemies <= 0 then
        battleM.currentBattle.bulletAnim = true
        util.tween.activeTweens["CamMoveX"] = nil
        util.tween.activeTweens["CamMoveY"] = nil
        util.tween.activeTweens["CamMoveZoom"] = nil
        util.tween.activeTweens["CamMoveRot"] = nil

        util.tween:tweenProperty(cam, "x", battleM.currentBattle.camTrans.x, 1, "CamResetX", "out")
        util.tween:tweenProperty(cam, "y", battleM.currentBattle.camTrans.y, 1, "CamReseteY", "out")
        util.tween:tweenProperty(cam, "zoom",  battleM.currentBattle.camTrans.zoom, 1, "CamResetZoom", "out")
        util.tween:tweenProperty(cam, "rot", 0, 1, "CamResetRot", "out")

        for b,b1 in pairs(battleM.moveButtons) do
            util.tween:tweenProperty(b1, "x",  playerM.player.x - 150, 0.7, "MoveButtonX"..b, "out")
            util.tween:tweenProperty(b1.label, "x",  playerM.player.x - 150, 0.7, "MoveButtonTextX"..b, "out")
        end

        infernoM.currentLayer.battlesWon = infernoM.currentLayer.battlesWon + 1

        util.time:runDeferred(1, function() enemyM:randomLayerSpawn(1, 4, lastEnemyX + 200) end)
    else
        battleM:repositionEnemies(lastEnemyX)
        battleM.currentBattle.bulletAnim = false
    end

end

function battleM:repositionEnemies(eX)
    if not battleM.currentBattle then return end
    local enemies = battleM.currentBattle.enemies
    local total = #enemies
    if total == 0 then return end

    local rows = 2
    local spacingX = 50
    local spacingY = 30
    local baseX = eX 
    local baseY = 80 

    for i, enemy in ipairs(enemies) do
        local col = math.floor((i-1) / rows)
        local row = (i-1) % rows

        local xPos = baseX + col * spacingX
        local yPos = baseY + row * spacingY

        util.tween:tweenProperty(enemy, "x", xPos, 0.5, "EnemyPosX"..i, "out")
        util.tween:tweenProperty(enemy, "y", yPos, 0.5, "EnemyPosY"..i, "out")

        if enemy.healthBar then
            util.tween:tweenProperty(enemy.healthBar, "x", xPos, 0.5, "EnemyHPX"..i, "out")
            util.tween:tweenProperty(enemy.healthBar, "y", yPos - 33, 0.5, "EnemyHPY"..i, "out")
        end

        battleM.currentBattle.enemyReturns[i] = {x = xPos, y = yPos}
    end
end



function battleM:startBattle(party,enemies)
    battleM.currentBattle = nil
    if battleM.currentBattle == nil then
        local enemyReturns = {}

        for e,e1 in pairs(enemies) do
            enemyReturns[e] = {x=e1.x, y=e1.y}
            e1.id = e
        end
         
        local battleEntry = {
            party = party,
            enemies = enemies,
            phase = "player",
            camTrans = {x=cam.x, y=cam.y, zoom=cam.zoom},
            bulletAnim = false,
            playerReturn = {x=playerM.player.x, y=playerM.player.y},
            enemyReturns = enemyReturns
        }

        battleM.currentBattle = battleEntry
        battleM:genMoveButtons()
        util.time:runDeferred(0, function() battleM:playerPhase() end)
    end
end

function battleM:playerPhase()
    for f,f1 in pairs(playerM.currentParty) do
        util.tween:tweenProperty(f1.healthBar, "offsetX", -200, 0.7, "HealthBarX"..f, "out")
    end

    for e,e1 in pairs(battleM.currentBattle.enemies) do
        util.tween:tweenProperty(e1.healthBar, "offsetX", 0, 0.7, "EnemyHealthBarX"..e, "out")
    end

    playerM.player.x = battleM.currentBattle.playerReturn.x
    playerM.player.y = battleM.currentBattle.playerReturn.y

    for t,t1 in pairs(enemyM.deletionTweens) do
        util.tween.activeTweens[t1.id] = nil
    end

    for e,e1 in pairs(battleM.currentBattle.enemies) do 
        

        e1.x = battleM.currentBattle.enemyReturns[e].x
        e1.y = battleM.currentBattle.enemyReturns[e].y
    end


    if battleM.currentBattle.phase == "enemy" then
        for f,f1 in ipairs(battleM.currentBattle.party) do
            util.tween:tweenProperty(f1, "x", f1.x + ((playerM.player.x - f1.x)*2) , 0.4, "FlowerXMove"..f, "out")
        end
        util.time:runDeferred(0.4, function() battleM:moveMoveButtons(1) end)
    else
        battleM:moveMoveButtons(1)
    end


    battleM.currentBattle.phase = "player"
    if battleM.currentBattle.playerCam == nil then
        util.tween:tweenProperty(cam, "x", battleM.currentBattle.camTrans.x + 45, 0.8, "CamMoveX", "out")
        util.tween:tweenProperty(cam, "y", battleM.currentBattle.camTrans.y + 40, 0.8, "CamMoveY", "out")
        util.tween:tweenProperty(cam, "zoom", 5.2, 0.8, "CamMoveZoom", "out")

        battleM.currentBattle.playerCam = {x=battleM.currentBattle.camTrans.x + 45, y=battleM.currentBattle.camTrans.y + 40, zoom=5.2}
    else
        util.tween:tweenProperty(cam, "x", battleM.currentBattle.playerCam.x, 0.8, "CamMoveX", "out")
        util.tween:tweenProperty(cam, "y", battleM.currentBattle.playerCam.y, 0.8, "CamMoveY", "out")
        util.tween:tweenProperty(cam, "zoom", battleM.currentBattle.playerCam.zoom, 0.8, "CamMoveZoom", "out")
    end

    

    
end

function battleM:enemyPhase()
    battleM.currentBattle.phase = "enemy"

    for e,e1 in pairs(battleM.currentBattle.enemies) do 
        e1:load()
    end

    for f,f1 in pairs(playerM.currentParty) do
        util.tween:tweenProperty(f1.healthBar, "offsetX", 0, 0.7, "HealthBarX"..f, "out")
    end

    for e,e1 in pairs(battleM.currentBattle.enemies) do
        util.tween:tweenProperty(e1.healthBar, "offsetX", 200, 0.7, "EnemyHealthBarX"..e, "out")
    end

    util.tween:tweenProperty(cam, "zoom", battleM.currentBattle.camTrans.zoom, 0.8, "CamMoveZoom", "out")
    util.tween:tweenProperty(cam, "x", battleM.currentBattle.camTrans.x, 0.8, "CamMoveX", "out")
    util.tween:tweenProperty(cam, "y", battleM.currentBattle.camTrans.y , 0.8, "CamMoveY", "out")

    for b,b1 in ipairs(battleM.moveButtons) do
        util.tween:tweenProperty(b1, "x", playerM.player.x - 150 , 0.7 + ((b-1) * 0.05), "MoveButtonX"..b, "out")
        util.tween:tweenProperty(b1.label, "x", playerM.player.x - 150 , 0.7 + ((b-1) * 0.05), "MoveButtonTextX"..b, "out")
    end

    for f,f1 in ipairs(battleM.currentBattle.party) do
        util.tween:tweenProperty(f1, "x", f1.x + ((playerM.player.x - f1.x)*2) , 0.6, "FlowerXMove"..f, "out")
    end

    util.time:runDeferred(battleM.currentBattle.enemies[1].attackDuration, function() battleM:playerPhase() end)
end

function battleM:moveMoveButtons(idx)
    for b,b1 in ipairs(battleM.moveButtons) do
        b1.flowerIdx = idx
        if battleM.currentBattle.party[idx] ~= nil then
            b1.sprite = util.sprites:getSprite(battleM.currentBattle.party[idx].data.v1.. "_move_button")
            util.tween:tweenProperty(b1, "x", battleM.currentBattle.party[idx].x + 45 - ((1-(b%2)) * 12), 0.7 + ((b-1) * 0.05), "MoveButtonX"..b, "out")
            util.tween:tweenProperty(b1, "y", battleM.currentBattle.party[idx].y - 45 + ((b-1) * 15), 0.7 + ((b-1) * 0.05), "MoveButtonY"..b, "out")

            util.tween:tweenProperty(b1.label, "x", battleM.currentBattle.party[idx].x + 45 - ((1-(b%2)) * 12), 0.7 + ((b-1) * 0.05), "MoveButtonTextX"..b, "out")
            util.tween:tweenProperty(b1.label, "y", battleM.currentBattle.party[idx].y - 45 + ((b-1) * 15), 0.7 + ((b-1) * 0.05), "MoveButtoTextY"..b, "out")

            if b == 2 and battleM.currentBattle.party[b1.flowerIdx].data.v3 == nil then break end

            if battleM.currentBattle.party[b1.flowerIdx].data.moveSet[b] ~= nil then
                b1.sprite = util.sprites:getSprite(battleM.currentBattle.party[b1.flowerIdx].data.moveSet[b].type.. "_move_button")
                    
                b1.label.changePallet(util.sprites.pallets[battleM.currentBattle.party[b1.flowerIdx].data.moveSet[b].type])
                b1.label.changeText(battleM.currentBattle.party[b1.flowerIdx].data.moveSet[b].name)
                
            end
        end
    end
end

battleM.moveSetValues = {
    chastity = {
        damage = 9,
        pierce = 3,
        prefix = "Pure",
        suffix = "Slash",
        primeName = "Sanctify"
    },
    charity = {
        damage = 6,
        pierce = 2,
        prefix = "Gift",
        suffix = "Strike",
        primeName = "Altruism"
    },
    kindness = {
        damage = 7,
        pierce = 2,
        prefix = "Gentle",
        suffix = "Jab",
        primeName = "Bloom"
    },
    temperance = {
        damage = 5,
        pierce = 4,
        prefix = "Calm",
        suffix = "Smash",
        primeName = "Balance"
    },
    diligence = {
        damage = 8,
        pierce = 3,
        prefix = "Steady",
        suffix = "Hit",
        primeName = "Endeavor"
    },
    patience = {
        damage = 6,
        pierce = 5,
        prefix = "Slow",
        suffix = "Thrust",
        primeName = "Still"
    },
    humility = {
        damage = 7,
        pierce = 6,
        prefix = "Low",
        suffix = "Sweep",
        primeName = "Bow"
    },
}



function battleM:addMoveSet(flower)
    local moveSet = {}

    flower.health = 100
    flower.maxHealth = 100


    if flower.data.v1 ~= nil then
        local typeV = flower.data.v1
        local damageV = battleM.moveSetValues[flower.data.v1].damage
        
        local pierceV = battleM.moveSetValues[flower.data.v1].pierce
        if flower.data.v2 ~= nil then pierceV = battleM.moveSetValues[flower.data.v2].pierce end

        local suffix = ""
        if flower.data.v2 then
            suffix = " ".. battleM.moveSetValues[flower.data.v2].suffix 
        else
            suffix = " ".. battleM.moveSetValues[flower.data.v1].suffix 
        end
        local name = battleM.moveSetValues[flower.data.v1].prefix.. suffix

        local move1 = {
            type = typeV,
            damage = damageV,
            pierce = pierceV,
            name = name
        }
        moveSet[1] = move1
        
    end

    if flower.data.v3 ~= nil then
        local typeV = flower.data.v3
        local damageV = battleM.moveSetValues[flower.data.v3].damage * 2
        local pierceV = battleM.moveSetValues[flower.data.v3].pierce * 1.5

        local move2 = {
            type = typeV,
            damage = damageV,
            pierce = pierceV,
            name = battleM.moveSetValues[flower.data.v3].primeName
        }
        moveSet[2] = move2
        
    end

    
    flower.data.moveSet = {}
    flower.data.moveSet = moveSet
end

function battleM:drawHealthBar(bar, percent)
    local w = bar.fullSprite:getWidth()
    local h = bar.fullSprite:getHeight()

    bar.sprite = bar.emptySprite
    util.sprites:drawObject(bar)

    love.graphics.stencil(function()
        love.graphics.rectangle(
            "fill",
            bar.x + bar.offsetX - w/2,
            bar.y - h/2,
            w * percent,
            h
        )
    end, "replace", 1)

    love.graphics.setStencilTest("greater", 0)

    bar.sprite = bar.fullSprite
    util.sprites:drawObject(bar)

    love.graphics.setStencilTest()
end

return battleM