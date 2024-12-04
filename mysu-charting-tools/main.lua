json = require "json" -- assuming you have a JSON library like dkjson or similar

local countdown = false
local count = 3
local clickData = {}
local recording = false
local musicFinished = false

function love.load()
    love.window.setTitle("mysuchartingtools.exe")
    flux = require "flux"
    target = {}
    target.x = 400
    target.y = 300
    target.radius = 50
    target.isMoving = false
    target.rotation = 0
    font = love.graphics.newFont(35)
    sound = love.audio.newSource("assets/snd/pop.wav", "static")
    background = love.graphics.newImage("assets/img/bg.png")
    target.image = love.graphics.newImage("assets/img/tyle.png")
    target.ox = target.image:getWidth() / 2
    target.oy = target.image:getHeight() / 2
    track = love.audio.newSource("assets/snd/mus/nokia.mp3", "static")
    trackname = string.match("assets/snd/mus/nokia.mp3", "([^/\\]+)$") -- dynamic extraction
end

function love.draw()
    for i = 0, love.graphics.getWidth() / background:getWidth() do
        for j = 0, love.graphics.getHeight() / background:getHeight() do
            love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
        end
    end

    love.graphics.setColor(255/255, 204/255, 204/255)
    love.graphics.draw(
        target.image,
        target.x,
        target.y,
        target.rotation,
        target.radius * 2 / target.image:getWidth(),
        target.radius * 2 / target.image:getHeight(),
        target.ox,
        target.oy
    )

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(font)
    love.graphics.print(trackname, 410, 3)

    -- Draw button
    love.graphics.setColor(0.2, 0.8, 0.2)
    love.graphics.rectangle("fill", 350, 500, 200, 50)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Start Music", 350, 515, 200, "center")

    -- Countdown display
    if countdown then
        love.graphics.printf(tostring(math.ceil(count)), 0, 300, love.graphics.getWidth(), "center")
    end

    -- Indicate recording
    if recording then
        love.graphics.printf("Recording...", 0, 550, love.graphics.getWidth(), "center")
    end
end

function love.update(dt)
    flux.update(dt)
    target.rotation = target.rotation + dt * 2
    if target.rotation > math.pi * 2 then
        target.rotation = target.rotation - math.pi * 2
    end

    if countdown then
        count = count - dt
        if count <= 0 then
            countdown = false
            recording = true
            love.audio.play(track)
        end
    end

    if recording and not track:isPlaying() and not musicFinished then
        musicFinished = true
        saveClicks()
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        if not countdown and not recording and x > 350 and x < 550 and y > 500 and y < 550 then
            countdown = true
            count = 3
        elseif recording then
            table.insert(clickData, {x = x, y = y, time = track:tell()})
        end
    end
end

function saveClicks()
    local jsonData = json.encode(clickData, {indent = true})
    local file = love.filesystem.newFile("click_data.json", "w")
    file:write(jsonData)
    file:close()
    print("Click data saved to click_data.json")
end

function distancebetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end
