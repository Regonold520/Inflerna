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
    local newEnemy = {
        x = x,
        y = 90,
        originY = enemyM.registeredEnemies[layerID][id].sprite:getHeight(),
        sprite = enemyM.registeredEnemies[layerID][id].sprite,
        script = enemyM.registeredEnemies[layerID][id].script,
        layer = enemyM.registeredEnemies[layerID][id].layerID
    }

    table.insert(enemyM.enemies, newEnemy)

    playerM:proceedForward(x - 150)

    return newEnemy
end

function enemyM:registerEnemy(id, layerID)
    if enemyM.registeredEnemies[layerID] == nil then enemyM.registeredEnemies[layerID] = {} end

    local enemy = {
        x = 0,
        y = 0,
        sprite = util.sprites:getSprite(id),
        script = require("scripts/enemies/".. layerID.. "/".. id),
        layer = layerID
    }

    enemyM.registeredEnemies[layerID][id] = enemy
end

return enemyM