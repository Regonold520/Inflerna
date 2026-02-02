local enemyM = {}

enemyM.registeredEnemies = {}

enemyM.enemies = {}

function enemyM:load()
    enemyM:registerEnemies()
end

function enemyM:update(dt)
end

function enemyM:draw()
end


function enemyM:registerEnemies()
    enemyM:registerEnemy("crawler", "limbo")
end

function enemyM:spawnEnemy(id, layerID, x)
    local scr = enemyM.registeredEnemies[layerID][id].script

    local attackDuration = scr.attackDuration or 1

    local newEnemy = {
        x = x,
        y = 90,
        originY = enemyM.registeredEnemies[layerID][id].sprite:getHeight(),
        sprite = enemyM.registeredEnemies[layerID][id].sprite,
        script = scr,
        shield = scr.shield,
        health = scr.health,
        layer = enemyM.registeredEnemies[layerID][id].layerID,
        attackDuration = attackDuration
    }

    newEnemy.hit = function(damage, pierce)
        local piercePercent = pierce / 10

        if piercePercent < 0 then piercePercent = 0 end
        if piercePercent > 0.9 then piercePercent = 0.9 end

        local effectiveShield = newEnemy.shield * (1 - piercePercent)

        local rawDamage = damage - effectiveShield

        local finalDamage = math.floor(rawDamage)
        if finalDamage < 1 then finalDamage = 1 end

        newEnemy.health = newEnemy.health - finalDamage

        if newEnemy.health <= 0 then newEnemy.die() else util.time:runDeferred(0.4,function()battleM.currentBattle.bulletAnim = false end) end
        print(newEnemy.health)
    end

    newEnemy.die = function()
        battleM:resetAfterKill(newEnemy)

        for e,e1 in pairs(enemyM.enemies) do
            if e1 == newEnemy then table.remove(enemyM.enemies, e) end
        end
    end

    table.insert(enemyM.enemies, newEnemy)

    playerM:proceedForward((x - 250)-playerM.player.x)
    battleM.currentBattle = nil

    return newEnemy
end

function enemyM:registerEnemy(id, layerID, health, shield)
    if enemyM.registeredEnemies[layerID] == nil then enemyM.registeredEnemies[layerID] = {} end

    local enemy = {
        x = 0,
        y = 0,
        sprite = util.sprites:getSprite(id),
        script = require("scripts/enemies/".. layerID.. "/".. id),
        layer = layerID,
        shield = shield,
        health = health
    }

    enemyM.registeredEnemies[layerID][id] = enemy
end

return enemyM