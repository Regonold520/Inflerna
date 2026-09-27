local steamM = {}

function steamM:load()
    local ok = steam.init()
    if not ok then
        print("Steam Init Failed")
    end
end

function steamM:update(dt)

end

function love.quit()
    steam.shutdown()
end

return steamM