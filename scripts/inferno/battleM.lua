local battleM = {}

battleM.currentBattle = nil

battleM.moveButtons = {}

function battleM:load()
end

function battleM:update(dt)
end

function battleM:draw()
    for b,b1 in ipairs(battleM.moveButtons) do
        util.sprites:drawObject(b1)
    end
end

function battleM:genMoveButtons()
    battleM.moveButtons = {}

    for i=1,2 do
        local moveButton = {
            x=playerM.player.x - 150,
            y=0,
            sprite = util.sprites:getSprite("flower_move_button"),
            flowerIdx = 0
        }
        
        moveButton.onClick = function()
            if battleM.currentBattle ~= nil then
                if battleM.currentBattle.phase == "player" then
                    print("grr cerising my cheller")
                    if moveButton.flowerIdx < #battleM.currentBattle.party then
                        battleM:moveMoveButtons(moveButton.flowerIdx + 1)
                    else
                        battleM:enemyPhase()
                    end
                end
            end
        end

        util.input:addClickable(moveButton,"inferno")

        battleM.moveButtons[i] = moveButton
    end
end

function battleM:startBattle(party,enemies)
    if battleM.currentBattle == nil then
        local battleEntry = {
            party = party,
            enemies = enemies,
            phase = "player",
            camTrans = {x=cam.x, y=cam.y, zoom=cam.zoom}
        }

        battleM.currentBattle = battleEntry
        battleM:genMoveButtons()
        util.time:runDeferred(0, function() battleM:playerPhase() end)
    end
end

function battleM:playerPhase()
    battleM.currentBattle.phase = "player"
    util.tween:tweenProperty(cam, "x", battleM.currentBattle.camTrans.x + 15, 0.8, "CamMoveX", "out")
    util.tween:tweenProperty(cam, "y", battleM.currentBattle.camTrans.y + 40, 0.8, "CamMoveY", "out")
    util.tween:tweenProperty(cam, "zoom", 5.2, 0.8, "CamMoveZoom", "out")

    battleM:moveMoveButtons(1)
end

function battleM:enemyPhase()
    battleM.currentBattle.phase = "enemy"
    print("enemyPhase start", cam.x, battleM.currentBattle.camTrans.x)

    util.tween:tweenProperty(cam, "zoom", battleM.currentBattle.camTrans.zoom, 0.8, "CamMoveZoom", "out")
    util.tween:tweenProperty(cam, "x", battleM.currentBattle.camTrans.x, 0.8, "CamMoveX", "out")
    util.tween:tweenProperty(cam, "y", battleM.currentBattle.camTrans.y , 0.8, "CamMoveY", "out")

    for b,b1 in ipairs(battleM.moveButtons) do
        util.tween:tweenProperty(b1, "x", playerM.player.x - 150 , 0.7 + ((b-1) * 0.05), "MoveButton"..b, "out")
    end
end

function battleM:moveMoveButtons(idx)
    for b,b1 in ipairs(battleM.moveButtons) do
        b1.flowerIdx = idx
        util.tween:tweenProperty(b1, "x", battleM.currentBattle.party[idx].x + 45 - ((1-(b%2)) * 12), 0.7 + ((b-1) * 0.05), "MoveButtonX"..b, "out")
        util.tween:tweenProperty(b1, "y", battleM.currentBattle.party[idx].y - 45 + ((b-1) * 15), 0.7 + ((b-1) * 0.05), "MoveButtonY"..b, "out")
    end
end

return battleM