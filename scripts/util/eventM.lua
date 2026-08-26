local eventM = {}

eventM.subscribedEvents = {}
eventM.postedEvents = {}

function eventM:await(id, func)
    local subscriber = {
        eventId = id,
        func = func
    }

    table.insert(eventM.subscribedEvents, subscriber)
end

local deltaTimer = 0
function eventM:update(dt)
    deltaTimer = deltaTimer + dt

    for _,i in pairs(eventM.subscribedEvents) do
        for j,x in pairs(eventM.postedEvents) do
            if i.eventId == x.eventId then
                i.func()
                table.remove(eventM.subscribedEvents, _)
            end
        end
    end
end

function eventM:emit(id)
    local poster = {
        eventId = id,
    }

    table.insert(eventM.postedEvents, poster)
    local removeId = #eventM.postedEvents

    util.time:runDeferred(1, function ()
        table.remove(eventM.postedEvents, removeId)
    end)
end

return eventM