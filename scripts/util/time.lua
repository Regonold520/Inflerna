local time = {}

time.cachedCalls = {}

function time:load()
end

local deltaTimer = 0
time.elapsedTime = 0
function time:update(dt)
    deltaTimer = deltaTimer + dt
    time.elapsedTime = deltaTimer

    if #time.cachedCalls > 0 then
        local count = 1
        for c,c1 in pairs(time.cachedCalls) do
            if time.elapsedTime >= c1.endTime then
                c1:call()

                table.remove(time.cachedCalls, count)
            end
            count = count + 1
        end
    end
end

function time:runDeferred(seconds,func)
    local newCall = {
        endTime = time.elapsedTime + seconds,
        call = func
    }

    table.insert(time.cachedCalls, newCall)
end

return time