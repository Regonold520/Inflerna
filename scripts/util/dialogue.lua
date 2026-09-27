local dialogue = {}

dialogue.dialogues = {}
dialogue.currentActor = nil

dialogue.tutorial = {
    fullyComplete = true,
    enter = false,
    altarEnter = false,
    altarExplain = false,
    altarSelect = false,
    seedCreated = false,
    seedTransported = false,
    returnToGarden = false,
    afterPlant = false,
    flowerBloomed = false,
    doorwayEnter = false,
    doorwaySelect = false
}

function dialogue:load()
    util.sprites:registerPallet({
            "#cfc6b8",
            "#eeaa6e",
            "#de9252",
            "#db7e4c",
            "#352e2e"
        }, "dialogueText") 

    dialogue.dialogues = lang.dialogue

    if dialogue.tutorial.fullyComplete == false and dialogue.tutorial.enter == false then
        dialogue.tutorial.enter = true
        util.time:runDeferred(1, function() dialogue:initiateDialogue("virgil", "gardenGreeting") end )
    end

    print(dialogue.dialogues["virgil"])
end

local deltaTimer = 0
function dialogue:update(dt)
    deltaTimer = deltaTimer + dt
    if dialogue.currentActor ~= nil then
        dialogue.currentActor.portraitSin = math.sin(deltaTimer*1.5) *8
    end
end

function dialogue:draw()
    if dialogue.currentActor ~= nil then
        love.graphics.setColor(0,0,0,dialogue.currentActor.rectOpacity)
        love.graphics.rectangle("fill",0,0,love.graphics:getWidth(),love.graphics:getHeight())
        love.graphics.setColor(1,1,1,1)



        local obj = dialogue.currentActor

        if dialogue.currentActor.obscured then
            love.graphics.setColor(0,0,0,1)
        end

        love.graphics.draw(obj.portraitSprite,love.graphics.getWidth() /2 + obj.x, love.graphics.getHeight() - 110 + obj.y + dialogue.currentActor.portraitSin, 0, cam.zoom, cam.zoom,
            obj.portraitSprite:getWidth()/2, obj.portraitSprite:getHeight())

        love.graphics.setColor(1,1,1,1)

        love.graphics.draw(obj.sprite,love.graphics.getWidth() / 2 + obj.x, love.graphics.getHeight() - 100 + obj.y, 0, cam.zoom, cam.zoom,
            obj.sprite:getWidth()/2, obj.sprite:getHeight()/2)

        love.graphics.draw(obj.namePlateSprite,love.graphics.getWidth() /2  - 470 + obj.x, love.graphics.getHeight() - 190 + obj.y, 0, cam.zoom, cam.zoom,
            obj.namePlateSprite:getWidth()/2, obj.namePlateSprite:getHeight()/2)

        if dialogue.currentActor.progressable then
            local obj2 = dialogue.currentActor.progressActor

            love.graphics.draw(obj2.icoSprite,love.graphics.getWidth() / 2 + dialogue.currentActor.x, love.graphics.getHeight() - 100 + dialogue.currentActor.y + (dialogue.currentActor.portraitSin/2), 0, cam.zoom, cam.zoom,
                obj2.icoSprite:getWidth()/2, obj2.icoSprite:getHeight()/2)
        end

        obj.txt.scaleX = cam.zoom/2.4
        obj.txt.scaleY = cam.zoom/2.4
        obj.txt.x = love.graphics.getWidth() /2 + obj.x - 570
        obj.txt.y = love.graphics.getHeight() /2 + obj.y + 285

        obj.txt:draw()

        obj.nameTxt.scaleX = cam.zoom/2.4
        obj.nameTxt.scaleY = cam.zoom/2.4
        obj.nameTxt.x = love.graphics.getWidth() /2 + obj.x - 471
        obj.nameTxt.y = love.graphics.getHeight() /2 + obj.y + 232

        obj.nameTxt:draw()
    end
end

function dialogue:unObscure()
    if dialogue.currentActor ~= nil then
        dialogue.currentActor.obscured = false
        dialogue.currentActor.nameTxt.changeText(dialogue.currentActor.charName)
    end
end

function dialogue:obscure()
    if dialogue.currentActor ~= nil then
        dialogue.currentActor.obscured = true
        dialogue.currentActor.nameTxt.changeText("???")
    end
end

function dialogue:writeLine(lineIDX)
    dialogue.currentActor.skipping = false
    dialogue.currentActor.currentLine = lineIDX
    local line = dialogue.currentActor.lines[lineIDX].text
    local total = ""

    if dialogue.currentActor.lines[lineIDX].func ~= nil then
        dialogue.currentActor.lines[lineIDX].func()
    end

    for i=1,#line do
        util.time:runDeferred(i / 15,
            function() 
                if dialogue.currentActor.skipping == false and dialogue.currentActor.currentLine == lineIDX then
                    total = total.. string.sub(line, i, i)
                    dialogue.currentActor.txt.changeText(total)
                    if i == #line then dialogue.currentActor.progressable = true end
                end
        end)
    end
end

function dialogue:initiateDialogue(character, dialogueID)
    local origCam = gardenM.cameraStatic
    gardenM.cameraStatic = true

    local lines = dialogue.dialogues[character][dialogueID]

    local txt = util.text:createText("dialogue", "", util.sprites.pallets.dialogueText, 550,true, true)
    local nameTxt = util.text:createText("dialogue", dialogue.dialogues[character].displayName, util.sprites.pallets.dialogueText, 550,false, true)

    local newActor = {
        x = 0,
        y = love.graphics:getHeight(),
        lines = lines,
        currentLine = 1,
        sprite = util.sprites:getSprite("dialogue_bg"),
        namePlateSprite = util.sprites:getSprite("dialogue_nameplate"),
        portraitSprite = util.sprites:getSprite(character.. "_portrait"),
        progressSprite = util.sprites:getSprite("dialogue_progress"),
        portraitSin = 0,
        rectOpacity = 0,
        txt = txt,
        nameTxt = nameTxt,
        charName = dialogue.dialogues[character].displayName,
        progressable = false,
        skipping = false,
        origCam = origCam
    }

    newActor.progressActor = {
        x = 0,
        y = 0,
        icoSprite = newActor.progressSprite,
        sprite = util.sprites:getSprite("SCREEN-CONSUMER"),
        layer = 999999
    }

    newActor.progressActor.onClick = function()
        if newActor.progressable then
            if newActor.currentLine + 1 <= #newActor.lines then
                newActor.progressable = false
                dialogue:writeLine(newActor.currentLine + 1)
                newActor.progressActor.active = true
            else
                dialogue:closeDialogue()
                newActor.progressActor.active = false
            end
        else
            if newActor.skipping == false then
                newActor.skipping = true
                local line = newActor.lines[newActor.currentLine].text
                newActor.txt.changeText(line)
                newActor.progressable = true
            end
        end
    end

    util.input:addClickable(newActor.progressActor,sceneM.activeScene, true)

    dialogue.currentActor = newActor

    dialogue:writeLine(1)
    
    util.tween:tweenProperty(dialogue.currentActor, "y", 0, 0.2, "DialogueY", "out")
    util.tween:tweenProperty(dialogue.currentActor, "rectOpacity", 0.4, 0.5, "DialogueOpacity", "out")

    for l,l1 in pairs(lines) do
        print(l1)
    end
end

function dialogue:closeDialogue()
    gardenM.cameraStatic = dialogue.currentActor.origCam

    util.tween:tweenProperty(dialogue.currentActor, "y", love.graphics:getHeight(), 0.5, "DialogueY", "out")
    util.tween:tweenProperty(dialogue.currentActor, "rectOpacity", 0, 0.5, "DialogueOpacity", "out")
end


return dialogue