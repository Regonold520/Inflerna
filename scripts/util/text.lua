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

function text:createText(id, string, pallet, boundX)
    pallet = pallet or util.sprites.pallets.text
    boundX = boundX or 0

    local newFont = love.graphics.newImageFont(
        util.sprites:palletSwapPath("assets/testFont.png", util.sprites.pallets.text, pallet),
        " abcdefghijklmnopqrstuvwxyz" ..
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
        "123456789.,!?-+/():;%&`'*#=[]\""
    )

    local newTxt = love.graphics.newText(newFont, string)

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
        originX = newTxt:getWidth() / 2,
        originY = newTxt:getHeight() / 2
    }

    newText.updateScale = function()
        if newText.boundX > 0 then
            local width = newText.textInstance:getWidth()
            if width > newText.boundX then
                local scaleFactor = newText.boundX / width
                newText.scaleX = math.min(scaleFactor, newText.baseScale)
                newText.scaleY = math.min(scaleFactor, newText.baseScale)
            else
                newText.scaleX = math.min(newText.scaleX, newText.baseScale)
                newText.scaleY = math.min(newText.scaleY, newText.baseScale)
            end
        end
    end

    newText.draw = function()
        newText:updateScale()
        love.graphics.draw(
            newText.textInstance,
            newText.x,
            newText.y,
            0,
            newText.scaleX,
            newText.scaleY,
            newText.originX,
            newText.originY
        )
    end

    newText.changeText = function(newStr)
        newText.textInstance:set(newStr)
        newText.rawText = newStr
        newText.originX = newText.textInstance:getWidth() / 2
        newText.originY = newText.textInstance:getHeight() / 2
    end

    newText.changePallet = function(newPallet)
        local newFont2 = love.graphics.newImageFont(
            util.sprites:palletSwapPath("assets/testFont.png", util.sprites.pallets.text, newPallet),
            " abcdefghijklmnopqrstuvwxyz" ..
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
            "123456789.,!?-+/():;%&`'*#=[]\""
        )
        newText.fontInstance = newFont2
        newText.textInstance = love.graphics.newText(newFont2, newText.rawText)
        newText.originX = newText.textInstance:getWidth() / 2
        newText.originY = newText.textInstance:getHeight() / 2
    end

    text.textObjects[id] = newText
    return newText
end

return text
