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

    
end

local deltaTimer = 0
function playerM:update(dt)
    print(#playerM.currentParty)
    deltaTimer = deltaTimer + dt
    playerM.player.scaleY = 1 + math.sin(deltaTimer*2)/20
    playerM.player.scaleX = 1 + math.cos(deltaTimer*2)/20
end

function playerM:draw()
    util.sprites:drawObject(playerM.player)

    for f,f1 in pairs(playerM.currentParty) do
        flowerM:drawIndividualFlower(f1, {
            face = {x=2}
        })
    end
end

function playerM:proceedForward(xAmount)
    local time = xAmount/100
    util.time:runDeferred(0.15, function() util.tween:tweenProperty(cam, "x", cam.x + xAmount, time - 0.15, "CamMoveX", "linear")   end)
    util.time:runDeferred(0.15, function() util.tween:tweenProperty(playerM.player, "x", playerM.player.x + xAmount, time - 0.15, "PlayerMoveX", "linear")   end)

    for f,f1 in pairs(playerM.currentParty) do
        util.time:runDeferred(0 + ((f%2)/20), function() util.tween:tweenProperty(f1, "x", f1.x + xAmount, time- (f/20), f.."MoveX", "linear")  end)
    end
end

return playerM