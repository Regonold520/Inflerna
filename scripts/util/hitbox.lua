local hitbox = {}

hitbox.hitboxes = {}

function hitbox:load()

end


local function rectsOverlap(a, b)
    return a.x + a.offsetX < b.x + b.offsetX + b.scaleX and
           a.x + a.offsetX + a.scaleX > b.x + b.offsetX and
           a.y + a.offsetY < b.y + b.offsetY + b.scaleY and
           a.y + a.offsetY + a.scaleY > b.y + b.offsetY
end


function hitbox:update(dt)
    for h,h1 in pairs(hitbox.hitboxes) do
        h1.x = h1.object.x
        h1.y = h1.object.y

        for i,h2 in pairs(hitbox.hitboxes) do
            if h1 ~= h2 then
                if rectsOverlap(h1, h2) then
                    if h1.overlappingBodies[h2.pV] == nil then
                        h1.overlappingBodies[h2.pV] = h2
                        if h1.object.hitboxEnter ~= nil then
                            h1.object.hitboxEnter(h2)
                        end
                    end
                else
                    if h1.overlappingBodies[h2.pV] ~= nil then
                        h1.overlappingBodies[h2.pV] = nil
                        if h1.object.hitboxExit ~= nil then
                            h1.object.hitboxExit(h2)
                        end
                    end
                end
                
            end
        end
    end
end 


function hitbox:draw()
    cam:attach() 

    love.graphics.setColor(0,1,0,1)

    for h,h1 in pairs(hitbox.hitboxes) do
        --love.graphics.rectangle("line",(h1.x - h1.scaleX/2) + h1.offsetX ,(h1.y - h1.scaleY/2) + h1.offsetY,h1.scaleX,h1.scaleY)
    end

    love.graphics.setColor(1,1,1,1)

    cam:detach()
end

function hitbox:createHitbox(object, id, scaleX, scaleY, offsetX, offsetY)
    offsetX = offsetX or 0
    offsetY = offsetY or 0

    local newHitbox = {
        x = 0,
        y = 0,
        object = object,
        scaleX = scaleX,
        scaleY = scaleY,
        offsetX = offsetX,
        offsetY = offsetY,
        overlappingBodies = {},
        pV = love.math.random(1,100000),
        sceneBegun = sceneM.activeScene
    }

    object.hitbox = newHitbox
    hitbox.hitboxes[id] = newHitbox
end

return hitbox