local input = {}

input.clickables = {}
input.mousejustpressed = false

function input:loopClickers()
    local mX, mY = getWorldMouse()

    for c,c1 in pairs(input.clickables) do
        if mX > c1.x - c1.sprite:getWidth()/2 and mX < c1.x + c1.sprite:getWidth()/2 then
            if mY > c1.y - c1.sprite:getHeight()/2 and mY < c1.y + c1.sprite:getHeight()/2 then
                if c1.onClick ~= nil then
                    c1:onClick()
                end
            end
        end
    end
end

function input:addClickable(obj)
    table.insert(input.clickables, obj)
end

return input