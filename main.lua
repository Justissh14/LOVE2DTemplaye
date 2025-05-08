if arg[2] == "debug" then
    require("lldebugger").start()
end

local Player = require("player")
local Bullet = require("bullet")

local player
local enemies = {}
local bullets = {}
local score = 0
local Lives = 1
local Timer = 0
local gameStarted = false
local gameOver = false
local showInfo = false

function love.load()
    love.window.setMode(800, 600, { resizable = true, vsync = true })
    love.window.setTitle("NoLove2D Game")

    font = love.graphics.newFont(30)
    smallFont = love.graphics.newFont(20)

    player = Player:new()
    spawnEnemies()
end

function spawnEnemies()
    enemies = {}
    local enemyImage = love.graphics.newImage("Assets/Images/NL2D_Enemy_alt.png")
    local minDistance = 100

    for i = 1, 5 do
        local safe = false
        local ex, ey

        while not safe do
            ex = math.random(0, 800)
            ey = math.random(0, 600)

            local dx = ex - player.x
            local dy = ey - player.y
            local distance = math.sqrt(dx * dx + dy * dy)

            if distance >= minDistance then
                safe = true
            end
        end

        table.insert(enemies, {
            x = ex,
            y = ey,
            width = 32,
            height = 50,
            speed = 50,
            image = enemyImage,
            touched = false
        })
    end
end

function updateEnemies(dt)
    for _, e in ipairs(enemies) do
        local dx = player.x - e.x
        local dy = player.y - e.y
        local dist = math.sqrt(dx * dx + dy * dy)

        if dist > 0 then
            e.x = e.x + (dx / dist) * e.speed * dt
            e.y = e.y + (dy / dist) * e.speed * dt
        end

        if checkCollision(player, e) then
            if not e.touched then
                e.touched = true
                Lives = Lives - 1
                print("Collision with enemy!")

                if Lives <= 0 then
                    gameOver = true
                    gameStarted = false
                end
            end
        else
            e.touched = false
        end
    end
end

function checkCollision(a, b)
    return a.x < b.x + b.width and
           a.x + a.width > b.x and
           a.y < b.y + b.height and
           a.y + a.height > b.y
end

function love.update(dt)
    if not gameStarted or gameOver or showInfo then return end

    player:update(dt)
    Timer = Timer + dt
    updateEnemies(dt)

    -- Update bullets
    for i = #bullets, 1, -1 do
        local b = bullets[i]
        b:update(dt)
        if b.x < 0 or b.x > 800 or b.y < 0 or b.y > 600 then
            table.remove(bullets, i)
        else
            -- Check collision with enemies
            for j = #enemies, 1, -1 do
                local e = enemies[j]
                if checkCollision(b, e) then
                    table.remove(enemies, j)
                    table.remove(bullets, i)
                    score = score + 1
                    break
                end
            end
        end
    end
end

function love.draw()
    if gameOver then
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(font)
        love.graphics.printf("Game Over! Press ENTER to restart.", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
        return
    end

    if not gameStarted then
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(font)

        if showInfo then
            love.graphics.printf("Game Tips:\n\n- Use WASD to move\n- Avoid enemies\n- Press SPACE to shoot\n- Press ENTER to start", 0, love.graphics.getHeight() / 2 - 100, love.graphics.getWidth(), "center")
            love.graphics.printf("Press ESC to go back", 0, love.graphics.getHeight() / 2 + 100, love.graphics.getWidth(), "center")
        else
            love.graphics.printf("Press ENTER to Start", 0, love.graphics.getHeight() / 2 - 100, love.graphics.getWidth(), "center")
            love.graphics.printf("Press Q for Info", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
        end
        return
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(smallFont)
    love.graphics.printf("Score: " .. score, 20, 13, love.graphics.getWidth(), "left")
    love.graphics.printf("Lives: " .. Lives, 150, 13, love.graphics.getWidth(), "left")
    love.graphics.printf("Timer: " .. Timer, 300, 13, love.graphics.getWidth(), "left")

    player:draw()

    for _, b in ipairs(bullets) do
        b:draw()
    end

    for _, e in ipairs(enemies) do
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(e.image, e.x, e.y, 0, e.width / e.image:getWidth(), e.height / e.image:getHeight())
    end
end

function love.keypressed(key)
    if key == "return" then
        if not gameStarted or gameOver then
            gameStarted = true
            gameOver = false
            Lives = 1
            score = 0
            Timer = 0
            player = Player:new()
            spawnEnemies()
            bullets = {}
            showInfo = false
        end
    elseif key == "q" then
        showInfo = not showInfo
    elseif key == "escape" then
        if showInfo then
            showInfo = false
        else
            love.event.quit()
        end
    elseif key == "space" then
        if gameStarted and not gameOver then
            local dx, dy = 0, 0
            if love.keyboard.isDown("up") then dy = -1 end
            if love.keyboard.isDown("down") then dy = 1 end
            if love.keyboard.isDown("left") then dx = -1 end
            if love.keyboard.isDown("right") then dx = 1 end

            if dx ~= 0 or dy ~= 0 then
                local length = math.sqrt(dx * dx + dy * dy)
                dx = dx / length
                dy = dy / length
                local bullet = Bullet(player.x + player.width / 2, player.y + player.height / 2, dx, dy)
                table.insert(bullets, bullet)
            end
        end
    end
end

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love.errorhandler(msg)
    end
end




