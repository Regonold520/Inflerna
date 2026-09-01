local harpy = {}

harpy.attackDuration = 10
harpy.health = 28
harpy.shield = 20
harpy.x = 0
harpy.y = 0

harpy.affinities = {"limbo"}

harpy.hitbox = {
    offsetX = 0,
    offsetY = -9,
    scaleX = 15,
    scaleY = 18
}

harpy.deletionTweens = {}

function harpy:load()
    
end

function harpy:update(dt)
    
end

return harpy