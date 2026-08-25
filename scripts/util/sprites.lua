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
    if newPallet ~= nil then
        if origPallet.size == newPallet.size then
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
end

local function hexToRGB(hex)
    hex = hex:gsub("#","")
    local r = tonumber(hex:sub(1,2),16)/255
    local g = tonumber(hex:sub(3,4),16)/255
    local b = tonumber(hex:sub(5,6),16)/255
    return r,g,b
end

function sprites:palletSwapPath(targetPath, origPallet, newPallet)
    if not newPallet then return end
    if #origPallet.colourData ~= #newPallet.colourData then return end

    local imgData = love.image.newImageData(targetPath)

    local map = {}
    for i=1,#origPallet.colourData do
        local oR,oG,oB = hexToRGB(origPallet.colourData[i])
        local nR,nG,nB = hexToRGB(newPallet.colourData[i])
        map[i] = {orig={oR,oG,oB}, new={nR,nG,nB}}
    end

    imgData:mapPixel(function(x,y,r,g,b,a)
        for _,v in ipairs(map) do
            local o,vv = v.orig, v.new
            if r==o[1] and g==o[2] and b==o[3] then
                return vv[1], vv[2], vv[3], a
            end
        end
        return r,g,b,a
    end)

    return imgData
end



function sprites:drawObject(obj)
    local sX = obj.scaleX or 1
    local sY = obj.scaleY or 1
    local oX = obj.originX or obj.sprite:getWidth()/2
    local oY = obj.originY or obj.sprite:getHeight()/2

    local offsetX = obj.offsetX or 0
    local offsetY = obj.offsetY or 0


    love.graphics.draw(obj.sprite, obj.x + offsetX, obj.y + offsetY, 0, sX, sY, oX, oY)
end

return sprites