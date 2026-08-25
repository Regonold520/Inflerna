local stateM = {}

stateM.states = {}

function stateM:registerState(id)
    stateM.states[id] = {
        rules = {}
    }
end

function stateM:addRuleType(type ,state, object, variant, expected)
    local newR = {
        type = type,
        obj = object,
        variant = variant,
        expected = expected
    }

    if stateM.states[state] ~= nil then
        local s = stateM.states[state]

        s.rules[#s.rules + 1] = newR
    end
end

function stateM:addBool(state, object, variant, expected)
    stateM:addRuleType("bool" ,state, object, variant, expected)
end

function stateM:addInt(state, object, variant, expected)
    stateM:addRuleType("int" ,state, object, variant, expected)
end

function stateM:addString(state, object, variant, expected)
    stateM:addRuleType("string" ,state, object, variant, expected)
end

function stateM:addExists(state, object, variant, expected)
    stateM:addRuleType("exists" ,state, object, variant, expected)
end

function stateM:getState(state)
    if stateM.states[state] ~= nil then

        for _, rule in pairs(stateM.states[state].rules) do
            if rule.type == "bool" or rule.type == "int" or rule.type == "string" then
                if rule.obj[rule.variant] ~= rule.expected then
                    return false
                end
            end

            if rule.type == "exists" then
                if (rule.obj[rule.variant] ~= nil) ~= rule.expected then
                    return false
                end
            end
        end

        return true
    else
        return false
    end
end


return stateM