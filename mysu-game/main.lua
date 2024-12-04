function love.load()
    windowtooltip = "The Worst osu! Clone"
    score = 0000000
    love.window.setTitle("MYsu! (wip title) - " .. windowtooltip .. " (" .. score .. ")")
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
    love.audio.play(track)
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
    love.graphics.print(score, 410, 3, 0)
end

function love.update(dt)
    flux.update(dt)
    target.rotation = target.rotation + dt * 2
    if target.rotation > math.pi * 2 then
        target.rotation = target.rotation - math.pi * 2
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 and not target.isMoving then
        local mouse2target = distancebetween(x, y, target.x, target.y)
        if mouse2target < target.radius then
            score = score + 1
            love.audio.setVolume = (math.random(.5,.8))
            love.audio.play(sound)
            target.radius = math.random(50, 55)
            love.window.setTitle("MYsu! - " .. windowtooltip .. " (" .. score .. ")")

            target.isMoving = true
            flux.to(target, 0.3, { x = math.random(target.radius, love.graphics.getWidth() - target.radius), y = math.random(target.radius, love.graphics.getHeight() - target.radius)})
            :oncomplete(function()
                target.isMoving = false
            end)
        
        else
            if score > 0 then
                miss1 = love.audio.newSource("assets/snd/miss/fail1.wav", "static")
                score = score - 1
                love.window.setTitle("MYsu! - " .. windowtooltip .. " (" .. score .. ")")
                love.audio.play(miss1)

            end
        end
    end
end

function love.keypressed(key)
    if (key == "z" or key == "x") and not target.isMoving then
        local mouse2target = distancebetween(love.mouse.getX(), love.mouse.getY(), target.x, target.y)
        if mouse2target < target.radius + 50 then
            score = score + 1
            love.audio.play(sound)
            target.radius = math.random(40, 70)
            love.window.setTitle("MYsu! - " .. windowtooltip .. " (" .. score .. ")")

            target.isMoving = true
            flux.to(target, 0.3, { x = math.random(target.radius, love.graphics.getWidth() - target.radius), y = math.random(target.radius, love.graphics.getHeight() - target.radius)})
            :oncomplete(function()
                target.isMoving = false
            end)
        
        else
            if score > 0 then
                miss1 = love.audio.newSource("assets/snd/miss/fail1.wav", "static")
                score = score - 1
                love.window.setTitle("MYsu! - " .. windowtooltip .. " (" .. score .. ")")
                love.audio.play(miss1)
            end
        end
    end
end

function distancebetween(x1, y1, x2, y2)
    return math.sqrt( (x2 - x1)^2 + (y2 - y1)^2)
end
