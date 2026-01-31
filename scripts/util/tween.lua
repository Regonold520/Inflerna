local tween = {}

tween.activeTweens = {}

function tween:createTween(startVal, endVal, duration, id, tweenType)
    local newTween = {
        startVal = startVal,
        endVal = endVal,
        duration = duration,
        elapsed = 0,
        value = startVal,
        tweenType = tweenType or "linear",
        sceneBegun = sceneM.activeScene
    }

    tween.activeTweens[id] = newTween
    return newTween
end

function tween:tweenProperty(object, key, endValue, duration, id, tweenType)
    local startValue = object[key]
    
    local newTween = {
        object = object,   
        key = key,        
        startVal = startValue,
        endVal = endValue,
        duration = duration,
        elapsed = 0,
        value = startValue,
        tweenType = tweenType or "linear",
        sceneBegun = sceneM.activeScene
    }

    tween.activeTweens[id] = newTween
    return newTween
end

function tween:update(dt)
    tween:updateTweens(dt)
end

function tween:updateTweens(dt)
    for id, t in pairs(tween.activeTweens) do
        t.elapsed = t.elapsed + dt

        local newValue
        if t.tweenType == "out" then
            newValue = tween:easeOut(t.startVal, t.endVal, t.elapsed, t.duration)
        elseif t.tweenType == "in" then
            newValue = tween:easeIn(t.startVal, t.endVal, t.elapsed, t.duration)
        else
            newValue = tween:lerpTimed(t.startVal, t.endVal, t.elapsed, t.duration)
        end

        t.value = newValue

        if t.object and t.key then
            t.object[t.key] = newValue
        end

        if t.elapsed >= t.duration then
            tween.activeTweens[id] = nil
        end
    end
end

function tween:clearSceneTweens(newScene)
    for id, tw in pairs(tween.activeTweens) do
        if tw.sceneBegun ~= newScene then
            tween.activeTweens[id] = nil
        end
    end
end


function tween:lerpTimed(startValue, endValue, elapsed, duration)
    local t = math.min(elapsed / duration, 1)
    return startValue + (endValue - startValue) * t
end

function tween:easeIn(startValue, endValue, elapsed, duration)
    local t = math.min(elapsed / duration, 1)
    t = t * t 
    return startValue + (endValue - startValue) * t
end

function tween:easeOut(startValue, endValue, elapsed, duration)
    local t = math.min(elapsed / duration, 1)
    t = 1 - (1 - t) * (1 - t) 
    return startValue + (endValue - startValue) * t
end

return tween