local playerM = {}

playerM.currentParty = {}

function playerM:load()
    playerM.player = {
        x = -100,
        y = -250,
        originY = util.sprites:getSprite("dante"):getHeight(),
        scaleY = 1,
        scaleX = 1,
        sprite = util.sprites:getSprite("dante")
    }

    playerM.player.hitboxEnter = function()
        print("they dont know i know this tech!")
    end

    playerM.player.hitboxExit = function()
        print("shit they knew :(")
    end

    util.hitbox:createHitbox(playerM.player, "Player", 16, 20, 2, -10)
end

local deltaTimer = 0
function playerM:update(dt)
    deltaTimer = deltaTimer + dt
    playerM.player.scaleY = 1 + math.sin(deltaTimer*2)/20
    playerM.player.scaleX = 1 + math.cos(deltaTimer*2)/20
end

function playerM:draw()
end

function playerM:proceedForward(xAmount)
    local time = xAmount/100
    util.time:runDeferred(0.15, function() util.tween:tweenProperty(cam, "x", cam.x + xAmount, time - 0.15, "CamMoveX", "linear")   end)
    util.time:runDeferred(0.15, function() util.tween:tweenProperty(playerM.player, "x", playerM.player.x + xAmount, time - 0.15, "PlayerMoveX", "linear")   end)

    for f,f1 in pairs(playerM.currentParty) do
        util.time:runDeferred(0.15, function() util.tween:tweenProperty(f1, "x", f1.x + xAmount, time - 0.15, f.."MoveX", "linear")  end)
    end

    
    util.time:runDeferred(time + 0.15, function() battleM:startBattle(playerM.currentParty,{enemyM.enemies[1]}) end)
end

return playerM