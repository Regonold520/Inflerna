local text = {}

text.textObjects = {}

function text:load()
    util.sprites:registerPallet({
        "#ffffff",
        "#eeaa6e",
        "#de9252",
        "#db7e4c",
        "#000000"
    }, "text") 
end

function text:createText(id, string, pallet, boundX, alignLeft, wrapText)
    pallet = pallet or util.sprites.pallets.text
    boundX = boundX or 0
    alignLeft = alignLeft or false
    wrapText = wrapText or false

    local newFont = love.graphics.newImageFont(
        util.sprites:palletSwapPath("assets/testFont.png", util.sprites.pallets.text, pallet),
        " abcdefghijklmnopqrstuvwxyz" ..
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
        "123456789.,!?-+/():;%&`'*#=[]\""
    )

    local newTxt = love.graphics.newText(newFont, "")
    
    local newText = {
        x = 0,
        y = 0,
        scaleX = 1,
        scaleY = 1,
        baseScale = 1,
        fontInstance = newFont,
        textInstance = newTxt,
        rawText = string,
        boundX = boundX,
        alignLeft = alignLeft,
        wrapText = wrapText,
        originX = 0,
        originY = 0,
        opacity = 1,
        rID = love.math.random(1,100000),
        rot = 0,
        id = id
    }

    newText.refreshText = function()
        if newText.wrapText and newText.boundX > 0 then
            newText.textInstance:setf(newText.rawText, newText.boundX, "left")
        else
            newText.textInstance:set(newText.rawText)
        end
        
        newText.originX = newText.alignLeft and 0 or (newText.textInstance:getWidth() / 2)
        newText.originY = newText.textInstance:getHeight() / 2 
        if newText.wrapText then
            newText.originY = 0
        end
    end

    newText.updateScale = function()
        newText.fitScale = 1 

        
        if not newText.wrapText and newText.boundX > 0 then
            local width = newText.textInstance:getWidth()
            if width > newText.boundX then
                newText.fitScale = newText.boundX / width
            end
        end
    end

    newText.draw = function()
        newText:updateScale()

        local width = newText.textInstance:getWidth()


        local fit = newText.fitScale

        if newText.allowUpscale == false then
            fit = math.min(1, fit)
        end

        love.graphics.setColor(1,1,1, newText.opacity)
            
        love.graphics.draw(
            newText.textInstance,
            newText.x,
            newText.y,
            newText.rot,
            newText.scaleX * fit, 
            newText.scaleY * fit,
            newText.originX,
            newText.originY
        )

        love.graphics.setColor(1,1,1,1)
    end


    newText.changeText = function(newStr)
        newText.rawText = newStr
        newText:refreshText()
    end

    newText.changePallet = function(newPallet)
        local newFont2 = love.graphics.newImageFont(
            util.sprites:palletSwapPath("assets/testFont.png", util.sprites.pallets.text, newPallet),
            " abcdefghijklmnopqrstuvwxyz" ..
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
            "123456789.,!?-+/():;%&`'*#=[]\""
        )
        newText.fontInstance = newFont2
        newText.textInstance = love.graphics.newText(newFont2, "")
        newText:refreshText()
    end

    newText:refreshText()
    
    text.textObjects[id] = newText
    return newText
end

function text:createRiseText(x, y, id, string, pallet, boundX, alignLeft, wrapText)
    local txt = text:createText(id, string, pallet, boundX, alignLeft, wrapText)
    txt.x, txt.y, txt.scaleX, txt.scaleY, txt.opacity = x, y, 5, 5, 1

    local newRot = love.math.random(-10, 10)
    local speed = 0.5

    util.tween:tweenProperty(txt, "x", txt.x + (newRot*1.5), speed, "txtX"..txt.rID , "out")
    util.tween:tweenProperty(txt, "y", txt.y - 100, speed, "txtY"..txt.rID , "out")
    
    util.tween:tweenProperty(txt, "rot", math.rad(txt.rot + newRot), speed, "txtRot"..txt.rID , "out")

    util.time:runDeferred(0.1, function() util.tween:tweenProperty(txt, "opacity", 0,speed - 0.1, "txtOpacity"..txt.rID , "out") end)

    return txt
end

return text