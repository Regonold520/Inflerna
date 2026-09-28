local jobs = love.thread.getChannel("meshJobs")
local result = love.thread.getChannel("meshResults")

local job = nil

function lerp(a, b, t)
    return a * (1-t) + b * t
end

while true do

    job = jobs:demand()

    local jobId = job.id

    local vertex = job.cornerVertex

    local tlX, tlY = vertex[1][1], vertex[1][2]
    local trX, trY = vertex[2][1], vertex[2][2]
    local brX, brY = vertex[3][1], vertex[3][2]
    local blX, blY = vertex[4][1], vertex[4][2]

    for k,v in pairs(job.meshVertices) do
        local topX = lerp(tlX, trX, v[3])
        local bottomX = lerp(blX, brX, v[3])

        local topY = lerp(tlY, trY, v[3])
        local bottomY = lerp(blY, brY, v[3])

        local pX = lerp(topX, bottomX, v[4])
        local pY = lerp(topY, bottomY, v[4])

        v[1] = pX
        v[2] = pY
    end

    result:push({
        id = jobId,
        verts = job.meshVertices
    })
end