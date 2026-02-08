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

-- Added alignLeft and wrapText parameters
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
        originY = 0
    }

    -- Helper to handle internal text setup (wrapping vs scaling)
    newText.refreshText = function()
        if newText.wrapText and newText.boundX > 0 then
            newText.textInstance:setf(newText.rawText, newText.boundX, "left")
        else
            newText.textInstance:set(newText.rawText)
        end
        
        -- originX: 0 for left-aligned, half-width for centered
        newText.originX = newText.alignLeft and 0 or (newText.textInstance:getWidth() / 2)
        
        -- originY: 0 pins the TOP of the text to newText.y
        -- This ensures wrapping only expands the text downwards.
        newText.originY = 0 
    end

    newText.updateScale = function()
        newText.fitScale = 1 -- Default to no scaling
        
        -- Only calculate a shrink-to-fit scale if NOT wrapping and boundX is set
        if not newText.wrapText and newText.boundX > 0 then
            local width = newText.textInstance:getWidth()
            if width > newText.boundX then
                newText.fitScale = newText.boundX / width
            end
        end
    end

    newText.draw = function()
        newText:updateScale()
        
        -- We multiply your external scaleX/Y by the internal fitScale
        love.graphics.draw(
            newText.textInstance,
            newText.x,
            newText.y,
            0,
            newText.scaleX * newText.fitScale, 
            newText.scaleY * newText.fitScale,
            newText.originX,
            newText.originY
        )
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

    -- Initial setup
    newText:refreshText()
    
    text.textObjects[id] = newText
    return newText
end

return text