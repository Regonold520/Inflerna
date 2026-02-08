local input = {}

input.mousejustpressed = false

input.showDebug = false

function input:loopClickers()
    local collectedLads = {}

    if sceneM.scenes[sceneM.activeScene] ~= nil then
        for c,c1 in pairs(sceneM.scenes[sceneM.activeScene].inputObjects) do

            if c1.active == false then goto continue end

            if c1.dead ~= nil then
                if c1.dead then
                    goto continue
                end
            end

            if not c1.sprite then
                goto continue
            end
            


            local mX, mY = getWorldMouse()
            if c1.isUi then
                mX, mY = love.mouse.getPosition()
                local halfW = (c1.sprite:getWidth() * cam.zoom) / 2
                local halfH = (c1.sprite:getHeight() * cam.zoom) / 2

                

                if mX > c1.x - halfW and mX < c1.x + halfW then
                    if mY > c1.y - halfH and mY < c1.y + halfH then
                        if c1.onClick then
                            table.insert(collectedLads, c1)
                        end
                    end
                end

            else
                if mX > c1.x - c1.sprite:getWidth()/2 and mX < c1.x + c1.sprite:getWidth()/2 then
                    if mY > c1.y - c1.sprite:getHeight()/2 and mY < c1.y + c1.sprite:getHeight()/2 then
                        if c1.onClick ~= nil then
                            table.insert(collectedLads, c1)
                        end
                    end
                end
            end
            ::continue::
        end
        
    end
    
    table.sort(collectedLads, function(a, b)
        return a.layer > b.layer
    end)

    if #collectedLads > 0 then
        collectedLads[1]:onClick()
    end

end

function input:markDead(obj)
    obj.dead = true
end

function input:cleanup()
    if sceneM.scenes[targetScene] ~= nil then
        for i = #sceneM.scenes[targetScene].inputObjects, 1, -1 do
            if sceneM.scenes[targetScene].inputObjects[i].dead then
                table.remove(sceneM.scenes[targetScene].inputObjects, i)
            end
        end
    end
end

input.layerColours = {}
function input:load()
    for i=-10, 2000 do
        local newColour = {
            r = love.math.random(),
            g = love.math.random(),
            b = love.math.random()
        }

        table.insert(input.layerColours, newColour)
    end
end

function input:addClickable(obj,targetScene ,isUi)
    isUi = isUi or false
    obj.isUi = isUi
    if obj.layer == nil then obj.layer = 0 end
    if obj.isUi then obj.layer = obj.layer + 999 end

    if sceneM.scenes[targetScene] ~= nil then
        table.insert(sceneM.scenes[targetScene].inputObjects, obj)
    end
end

function input:removeClickable(obj)
    for c,c1 in pairs(sceneM.scenes[targetScene].inputObjects) do
        if c1 == obj then table.remove(sceneM.scenes[targetScene].inputObjects, c) end
    end
end

function input:draw()
    if sceneM.scenes[sceneM.activeScene] ~= nil and input.showDebug then 
        local clickers = sceneM.scenes[sceneM.activeScene].inputObjects
        table.sort(clickers, function(a, b)
            return a.layer < b.layer
        end)

        for c,c1 in pairs(clickers) do
            love.graphics.setColor(input.layerColours[c1.layer+10].r,input.layerColours[c1.layer+10].g,input.layerColours[c1.layer+10].b,1)
            if c1.isUi == false then
                love.graphics.setLineWidth(1)
                cam:attach() 
                love.graphics.rectangle("line",c1.x - c1.sprite:getWidth()/2,c1.y - c1.sprite:getHeight()/2,c1.sprite:getWidth(),c1.sprite:getHeight())
                cam:detach()
            else
                love.graphics.setLineWidth(4)
                love.graphics.rectangle("line",c1.x - c1.sprite:getWidth()/2*cam.zoom,c1.y - c1.sprite:getHeight()/2*cam.zoom,c1.sprite:getWidth()*cam.zoom,c1.sprite:getHeight()*cam.zoom)
            end
            
        end
        love.graphics.setColor(1,1,1,1)
    end
end

return input