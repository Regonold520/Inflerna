local crawler = {}

crawler.attackDuration = 10
crawler.health = 18
crawler.shield = 10
crawler.x = 0
crawler.y = 0

crawler.affinities = {"limbo"}

crawler.hitbox = {
    offsetX = 0,
    offsetY = -9,
    scaleX = 15,
    scaleY = 18
}

crawler.deletionTweens = {}

function crawler:load()
    util.time:runDeferred(2, function() self:jump() end)
end

function crawler:jump()
    self.deletionTweens = {}
    local angle = math.atan2(playerM.player.y - self.y, playerM.player.x - self.x)

    local xOffset = math.cos(angle)
    local yOffset = math.sin(angle)
    local mult = 100

    if xOffset > 0 then self.scaleX = -1 elseif xOffset < 0 then self.scaleX = 1 end

    enemyM:protectedTween(self, "x", self.x - (xOffset * 10), 0.5, "CrawlerMoveX"..self.uid, "out")
    enemyM:protectedTween(self, "y", self.y - (yOffset * 10), 0.5, "CrawlerMoveY..self.uid", "out")
    if battleM.currentBattle ~= nil then
        util.time:runDeferred(0.5 ,  function() enemyM:protectedTween(self, "x", clamp(battleM.currentBattle.playerReturn.x - 10, self.x + (xOffset * mult), battleM.currentBattle.playerReturn.x + 230), 1.7, "CrawlerMoveX"..self.uid, "out") end)
        util.time:runDeferred(0.5 ,  function() enemyM:protectedTween(self, "y", clamp(battleM.currentBattle.playerReturn.y - 16, self.y + (yOffset * mult), battleM.currentBattle.playerReturn.y + 34), 1.7, "CrawlerMoveY"..self.uid, "out") end)
    end
    
    

    


    if battleM.currentBattle.phase == "enemy" then
        util.time:runDeferred(2.5, function() self:jump() end)
    end
end

function crawler:update(dt)
    
end

return crawler