local flowerM = {}

function Color(hex, value)
	return {tonumber(string.sub(hex, 2, 3), 16)/256, tonumber(string.sub(hex, 4, 5), 16)/256, tonumber(string.sub(hex, 6, 7), 16)/256, 1 or 1}
end

flowerM.flowers = {}

function flowerM:load()
    flowerM:registerFlowerData()
    

    local flowerData = {
        v1 = "charity"
    }

    flowerM:generateFlower(flowerData)
end

function flowerM:registerFlowerData()
    util.sprites:registerPallet({
        "#ffcbcb",
        "#ffb9b9",
        "#f5a3ab",
        "#e5949d",
        "#774e50"
    }, "charity")

    util.sprites:registerPallet({
        "#ff9831",
        "#f58f29",
        "#ee7a18",
        "#e55d15",
        "#742d08"
    }, "diligence")

    util.sprites:registerPallet({
        "#f4fcfb",
        "#e4f2f0",
        "#c8dbda",
        "#b1c4c7",
        "#61676d"
    }, "chastity")

    util.sprites:registerPallet({
        "#d4eb56",
        "#c7de4d",
        "#b2d138",
        "#9cbd2d",
        "#566a13"
    }, "kindness")

    util.sprites:registerPallet({
        "#c075b7",
        "#b66dad",
        "#a95ba3",
        "#954d95",
        "#673467"
    }, "patience")

    util.sprites:registerPallet({
        "#adf9fc",
        "#9deff2",
        "#83e5eb",
        "#7cd2e1",
        "#3b6b74"
    }, "temperance")

    util.sprites:registerPallet({
        "#f5b176",
        "#eeaa6e",
        "#de9252",
        "#db7e4c",
        "#844727"
    }, "humility")

end

function flowerM:generateFlower(flowerInputs)
    local newFlower = {
        x = love.graphics:getWidth()/2,
        y = love.graphics:getHeight()/2,
        data = flowerInputs,
        sprites = {
            head = util.sprites:getSprite(flowerInputs.v1.. "-head")
        }
    }

    newFlower.sprites.head = util.sprites:palletSwap(newFlower.sprites.head, util.sprites.pallets.flowergray, util.sprites.pallets.humility)

    table.insert(flowerM.flowers, newFlower)
end

function flowerM:draw()
    for _,flower in pairs(flowerM.flowers) do
        love.graphics.draw(flower.sprites.head, flower.x, flower.y, 0, 10, 10)
    end
end

return flowerM