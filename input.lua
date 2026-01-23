local input = {}

input.mousejustpressed = false

function input:loopClickers()
    if sceneM.scenes[sceneM.activeScene] ~= nil then
        for c,c1 in pairs(sceneM.scenes[sceneM.activeScene].inputObjects) do

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
                        if c1.onClick then c1:onClick() end
                    end
                end

            else
                if mX > c1.x - c1.sprite:getWidth()/2 and mX < c1.x + c1.sprite:getWidth()/2 then
                    if mY > c1.y - c1.sprite:getHeight()/2 and mY < c1.y + c1.sprite:getHeight()/2 then
                        if c1.onClick ~= nil then
                            c1:onClick()
                        end
                    end
                end
            end
            ::continue::
        end
        
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


function input:addClickable(obj,targetScene ,isUi)
    isUi = isUi or false
    obj.isUi = isUi
    if sceneM.scenes[targetScene] ~= nil then
        table.insert(sceneM.scenes[targetScene].inputObjects, obj)
    end
end

function input:removeClickable(obj)
    for c,c1 in pairs(sceneM.scenes[targetScene].inputObjects) do
        if c1 == obj then table.remove(sceneM.scenes[targetScene].inputObjects, c) end
    end
end

return input