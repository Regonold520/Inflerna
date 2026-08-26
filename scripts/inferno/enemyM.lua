local enemyM = {}

enemyM.registeredEnemies = {}

enemyM.enemies = {}
enemyM.deletionTweens = {}

function enemyM:load()
    enemyM:registerEnemies()
    util.eventM:emit("enemiesLoaded")
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

function enemyM:hurtFlower(idx, damage, uid)
    if battleM.currentBattle ~= nil then
        battleM.currentBattle.party[idx].health = battleM.currentBattle.party[idx].health - damage 
        print("Hi im",uid)
        if battleM.currentBattle.party[idx].health <= 0 then
            table.remove(playerM.currentParty,idx)
        end

        if #battleM.currentBattle.party <= 0 then
            sceneM:switchScene("inferno")
        end
    end
end

function enemyM:spawnEnemies(enemies, x)
    local rows = 2
    local spacingX = 40
    local spacingY = 30
    local baseX = x      
    local baseY = 80        

    for i, e1 in ipairs(enemies) do
        local enemyData = enemyM.registeredEnemies[e1.layerID][e1.id]
        local attackDuration = enemyData.attackDuration or 1
        local newEnemy = deepCopy(enemyData)
        local uid = love.math.random(1, 100000)
        newEnemy.uid = uid
        newEnemy.maxHealth = newEnemy.health

        newEnemy.healthBar = {
            x = newEnemy.x,
            y = newEnemy.y,
            offsetX = 200,
            offsetY = 0,
            fullSprite = util.sprites:getSprite("healthbar-full"),
            emptySprite = util.sprites:getSprite("healthbar-empty"),
            sprite = util.sprites:getSprite("healthbar-full")
        }

        util.hitbox:createHitbox(newEnemy, e1.id.. uid, newEnemy.hitbox.scaleX, newEnemy.hitbox.scaleY, newEnemy.hitbox.offsetX, newEnemy.hitbox.offsetY)

        local col = math.floor((i-1) / rows)
        local row = (i-1) % rows

        newEnemy.x = baseX + col * spacingX
        newEnemy.y = baseY + row * spacingY
        newEnemy.originY = enemyM.registeredEnemies[e1.layerID][e1.id].sprite:getHeight()

        newEnemy.hit = function(damage, pierce)
            local piercePercent = pierce / 10

            if piercePercent < 0 then piercePercent = 0 end
            if piercePercent > 0.9 then piercePercent = 0.9 end

            local effectiveShield = newEnemy.shield * (1 - piercePercent)

            local rawDamage = damage - effectiveShield

            local finalDamage = math.floor(rawDamage)
            if finalDamage < 1 then finalDamage = 1 end

            newEnemy.health = newEnemy.health - finalDamage

            battleM.bullets = {}

            if newEnemy.health <= 0 then newEnemy.die() else util.time:runDeferred(0.8,function()
                if battleM.currentBattle.phase == "player" then
                    battleM.currentBattle.bulletAnim = false
                end
            end) end
        end

        newEnemy.die = function()
            battleM:resetAfterKill(newEnemy)
            for h,h1 in pairs(util.hitbox.hitboxes) do
                if h1 == newEnemy.hitbox then util.hitbox.hitboxes[h] = nil end
            end

            for e,e1 in pairs(enemyM.enemies) do
                if e1 == newEnemy then table.remove(enemyM.enemies, e) end
            end
        end

        newEnemy.hitboxEnter = function(overlapping)
            print("Enemy overlaps player?", overlapping.pV, playerM.player.hitbox.pV)

            if overlapping.pV == playerM.player.hitbox.pV then
                enemyM:hurtFlower(love.math.random(1,#battleM.currentBattle.party), 40,newEnemy.uid)
            end
        end


        table.insert(enemyM.enemies, newEnemy)
    end

    playerM:proceedForward((x - 250)-playerM.player.x)
    battleM.currentBattle = nil

end

function enemyM:randomLayerSpawn(min, max, distance)
    local count = love.math.random(min, max)
    local collated = {}
    for i=1,count do 
        local newID = infernoM.currentLayer.enemyPool[math.random(#infernoM.currentLayer.enemyPool)]
        local newLayerID = infernoM.currentLayer.id
        local entry = {id=newID, layerID=newLayerID}
        table.insert(collated, entry)
    end

    enemyM:spawnEnemies(collated, distance)
end


function enemyM:registerEnemy(id, layerID)
    if enemyM.registeredEnemies[layerID] == nil then enemyM.registeredEnemies[layerID] = {} end

    local enemy = require("scripts/enemies/"..layerID.. "/"..id)
    enemy.sprite = util.sprites:getSprite(id)
    enemy.layer = layerID
    enemy.name = id

    enemyM.registeredEnemies[layerID][id] = enemy
end

return enemyM