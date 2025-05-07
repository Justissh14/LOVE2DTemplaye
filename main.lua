

if arg[2] == "debug" then
    require("lldebugger").start()
end

local Player = require("player")
local player
local enemies = {}
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

function checkCollision(player, enemy)
    return player.x < enemy.x + enemy.width and
           player.x + player.width > enemy.x and
           player.y < enemy.y + enemy.height and
           player.y + player.height > enemy.y
end

function love.update(dt)
    if not gameStarted or gameOver or showInfo then return end

    player:update(dt)
    Timer = Timer + dt
    updateEnemies(dt)
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
            love.graphics.printf("Game Tips:\n\n- Use WASD to move\n- Avoid enemies\n- Press ENTER to start", 0, love.graphics.getHeight() / 2 - 100, love.graphics.getWidth(), "center")
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
    love.graphics.printf("player.x: " .. player.x, 20, 50, love.graphics.getWidth(), "left")
    love.graphics.printf("player.y: " .. player.y, 20, 80, love.graphics.getWidth(), "left")

    player:draw()

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
            showInfo = false
            if love.keyboard.isDown("up") then player:Shoot() end
            if love.keyboard.isDown("up") and love.keyboard.isDown("left")  then player:Shoot() end
            if love.keyboard.isDown("up") and love.keyboard.isDown("right") then player:Shoot() end
            if love.keyboard.isDown("down") then player:Shoot() end
            if love.keyboard.isDown("down") and love.keyboard.isDown("left") then player:Shoot() end
            if love.keyboard.isDown("down") and love.keyboard.isDown("right") then player:Shoot() end
            if love.keyboard.isDown("left") then player:Shoot() end
            if love.keyboard.isDown("right") then player:Shoot() end
        end
    elseif key == "q" then
        showInfo = not showInfo
    elseif key == "escape" then
        if showInfo then
            showInfo = false
        else
            love.event.quit()
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



