local enemyM = {}

enemyM.registeredEnemies = {}

enemyM.enemies = {}
enemyM.deletionTweens = {}

function enemyM:load()
    enemyM:registerEnemies()
end

function enemyM:update(dt)
end

function enemyM:draw()
end

local function deepCopy(orig, seen)
    if type(orig) ~= "table" then
        return orig
    end

    if seen and seen[orig] then
        return seen[orig]
    end

    local copy = {}
    seen = seen or {}
    seen[orig] = copy

    for k, v in pairs(orig) do
        copy[deepCopy(k, seen)] = deepCopy(v, seen)
    end

    return setmetatable(copy, getmetatable(orig))
end

function enemyM:registerEnemies()
    enemyM:registerEnemy("crawler", "limbo")
end

function enemyM:protectedTween(obj, property, final, time, id, lerp)
    if battleM.currentBattle == nil or battleM.currentBattle.phase ~= "enemy" then return end
    table.insert(enemyM.deletionTweens, util.tween:tweenProperty(obj, property, final, time, id, lerp))
end

function enemyM:hurtFlower(idx, damage)
    if battleM.currentBattle ~= nil then
        battleM.currentBattle.party[idx].health = battleM.currentBattle.party[idx].health - damage 
        if battleM.currentBattle.party[idx].health <= 0 then
            table.remove(playerM.currentParty,idx)
        end

        if #battleM.currentBattle.party <= 0 then
            sceneM:switchScene("inferno")
        end
    end
end

function enemyM:spawnEnemy(id, layerID, x)
    local attackDuration = enemyM.registeredEnemies[layerID][id].attackDuration or 1

    local newEnemy = deepCopy(enemyM.registeredEnemies[layerID][id])

    newEnemy.maxHealth = newEnemy.health

    newEnemy.healthBar = {
        x = newEnemy.x,
        y = newEnemy.y,
        offsetX = 200,
        offsetY = 0,
        fullSprite = util.sprites:getSprite("healthbar-full"),
        emptySprite = util.sprites:getSprite("healthbar-empty"),
        sprite = util.sprites:getSprite("healthbar-full"),
    }

    util.hitbox:createHitbox(newEnemy, id, newEnemy.hitbox.scaleX, newEnemy.hitbox.scaleY, newEnemy.hitbox.offsetX, newEnemy.hitbox.offsetY)
    
    newEnemy.x = x
    newEnemy.y = 90
    newEnemy.originY = enemyM.registeredEnemies[layerID][id].sprite:getHeight()

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


function enemyM:registerEnemy(id, layerID)
    if enemyM.registeredEnemies[layerID] == nil then enemyM.registeredEnemies[layerID] = {} end

    local enemy = require("scripts/enemies/"..layerID.. "/"..id)
    enemy.sprite = util.sprites:getSprite(id)
    enemy.layer = layerID

    enemyM.registeredEnemies[layerID][id] = enemy
end

return enemyM