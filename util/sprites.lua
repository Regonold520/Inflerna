local sprites = {}

sprites.spriteBank = {}
sprites.pallets = {}

function sprites:registerPallet(colours, id)
    local newEntry = {
        colourData = colours,
        size = #colours
    }

    sprites.pallets[id] = newEntry
end

function string:endswith(suffix)
    return self:sub(-#suffix) == suffix
end

function sprites:load()
    sprites:bankSprites()

    sprites:registerPallet({
        "#d6d6d6",
        "#c7c7c7",
        "#b5b5b5",
        "#a5a5a5",
        "#565656"
    }, "flowergray")
end

function sprites:bankSprites()
    local dirsToCheck = {}

    table.insert(dirsToCheck, "assets")

    while #dirsToCheck > 0 do
        for _,i in pairs(dirsToCheck) do
            local dirItems = love.filesystem.getDirectoryItems(i)
            for c,item in pairs(dirItems) do 
                local filePath = i .."/" ..item
                local fileID = love.filesystem.getInfo(filePath).type
                
                if fileID == "directory" then
                    table.insert(dirsToCheck, filePath)
                elseif fileID == "file" then
                    if filePath:endswith(".png") then
                        local newEntry = {
                            path = filePath,
                            name = item,
                            sprite = love.graphics.newImage(filePath)
                        }


                        table.insert(sprites.spriteBank, newEntry)
                    end
                end
                
            end


            table.remove(dirsToCheck,_)
        end
    end
end

function sprites:getSprite(spriteName)
    for _,i in pairs(sprites.spriteBank) do

        if i.name == spriteName.. ".png" then 
            return i.sprite
        end
    end
end

function sprites:getPathFromSprite(searchSprite)
    for _,i in pairs(sprites.spriteBank) do
        if i.sprite == searchSprite then 
            return i.path
        end
    end
end

local function almostEqual(a,b,epsilon)
    epsilon = epsilon or 0.01
    return math.abs(a-b) < epsilon
end

function sprites:palletSwap(targetSprite, origPallet, newPallet)
    if #origPallet == #newPallet then
        local imgData = love.image.newImageData(sprites:getPathFromSprite(targetSprite))

        imgData:mapPixel(function(x, y, r, g, b, a)
            local newR, newG, newB = r,g,b

        

            for _,i in pairs(origPallet.colourData) do
                if almostEqual(r, Color(origPallet.colourData[_])[1]) then
                    newR = Color(newPallet.colourData[_])[1]
                end

                if almostEqual(g, Color(origPallet.colourData[_])[2]) then
                    newG = Color(newPallet.colourData[_])[2]
                end

                if almostEqual(b, Color(origPallet.colourData[_])[3]) then
                    newB = Color(newPallet.colourData[_])[3]
                end
            end

            return newR, newG, newB, a
        end)

        return love.graphics.newImage(imgData)
    end
end

return sprites