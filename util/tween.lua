local tween = {}

tween.activeTweens = {}

function tween:createTween(startVal, endVal, duration, id, tweenType)
    local chosenType = tweenType or nil
    local newTween = {
        startVal = startVal,
        endVal = endVal,
        duration = duration,
        elapsed = 0,
        value = startVal,
        tweenType = chosenType
    }

    tween.activeTweens[id] = newTween
    return newTween
end

function tween:update(dt)
    tween:updateTweens(dt)
end

function tween:updateTweens(dt)
    for t,t1 in pairs(tween.activeTweens) do
        t1.elapsed = t1.elapsed + dt

        if t1.tweenType == "out" then
            t1.value = tween:easeOut(t1.startVal, t1.endVal, t1.elapsed, t1.duration)
        elseif t1.tweenType == "in" then
            t1.value = tween:easeIn(t1.startVal, t1.endVal, t1.elapsed, t1.duration)
        else
            t1.value = tween:lerpTimed(t1.startVal, t1.endVal, t1.elapsed, t1.duration)
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