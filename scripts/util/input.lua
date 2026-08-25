local input = {}

input.mousejustpressed = false

input.showDebug = false

input.hovering = {}

function input:loopClickers()
    local collectedLads = {}
    local scene = sceneM.scenes[sceneM.activeScene]
    if not scene then return end

    local worldMX, worldMY = getWorldMouse()
    local uiMX, uiMY = love.mouse.getPosition()

    for _, obj in pairs(scene.inputObjects) do
        if obj.active == false or obj.dead or not obj.sprite then goto continue end

        local scaleX, scaleY = obj.scaleX or 1, obj.scaleY or 1

        local left, right, top, bottom
        local mX, mY

        if obj.isUi then
            mX, mY = uiMX, uiMY

            local halfW = (obj.sprite:getWidth()* cam.zoom* scaleX) / 2
            local halfH = (obj.sprite:getHeight()* cam.zoom* scaleY) / 2
            left, right = obj.x - halfW, obj.x + halfW
            top, bottom = obj.y - halfH, obj.y + halfH
        else
            mX, mY = worldMX, worldMY

            local halfW = obj.sprite:getWidth()/2 * scaleX
            local halfH = obj.sprite:getHeight()/2 * scaleY
            left, right = obj.x - halfW, obj.x + halfW
            top, bottom = obj.y - halfH, obj.y + halfH
        end

        local hoveringNow = mX > left and mX < right and mY > top and mY < bottom
        local wasHovering, _ = input:inHovering(obj)

        if hoveringNow and not wasHovering then
            if obj.onHoverEnter then obj:onHoverEnter() end
            table.insert(input.hovering, obj)
        elseif not hoveringNow and wasHovering then
            if obj.onHoverExit then obj:onHoverExit() end
            for i, hObj in ipairs(input.hovering) do
                if hObj == obj then
                    table.remove(input.hovering, i)
                    break
                end
            end
        end

        if hoveringNow and obj.onClick then
            table.insert(collectedLads, obj)
        end

        ::continue::
    end

    table.sort(collectedLads, function(a,b) return a.layer > b.layer end)
    if #collectedLads > 0 and util.input.mousejustpressed then
        collectedLads[1]:onClick()
        util.input.mousejustpressed = false
    end
end



function input:inHovering(obj)
    for _, o1 in pairs(input.hovering) do
        if o1 == obj then
            return true, o1
        end
    end
    return false, nil
end


function input:markDead(obj)
    obj.dead = true
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

function input:update(dt)
    if sceneM.scenes[sceneM.activeScene] ~= nil then
        for i = #sceneM.scenes[sceneM.activeScene].inputObjects, 1, -1 do
            if sceneM.scenes[sceneM.activeScene].inputObjects[i].dead then
                table.remove(sceneM.scenes[sceneM.activeScene].inputObjects, i)
            end
        end
    end


    input.mousejustpressed = false
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
            local scaleX = c1.scaleX or 1
            local scaleY = c1.scaleY or 1
            love.graphics.setColor(input.layerColours[c1.layer+10].r,input.layerColours[c1.layer+10].g,input.layerColours[c1.layer+10].b,1)
            if c1.isUi == false then
                love.graphics.setLineWidth(1)
                cam:attach() 
                if c1.sprite ~= nil then
                    love.graphics.rectangle("line",c1.x - c1.sprite:getWidth()/2,c1.y - c1.sprite:getHeight()/2,c1.sprite:getWidth(),c1.sprite:getHeight())
                end
                cam:detach()
            else
                love.graphics.setLineWidth(4)
                love.graphics.rectangle("line",c1.x - (c1.sprite:getWidth()/2* scaleX)*cam.zoom,c1.y - (c1.sprite:getHeight()/2* scaleY)*cam.zoom,(c1.sprite:getWidth()* scaleX)*cam.zoom,(c1.sprite:getHeight()* scaleY)*cam.zoom)
            end
            
        end
        love.graphics.setColor(1,1,1,1)
    end
end

return input