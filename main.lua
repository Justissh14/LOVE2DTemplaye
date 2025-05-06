
if arg[2] == "debug" then
    require("lldebugger").start()
end

local mainMenu = require("mainMenu")
local gameStarted = false

player = { x = 100, y = 100, width = 32, height = 50, speed = 200 }

local enemies = {}
local enemyImage
local score = 0
local collided = false

function love.load()
    mainMenu.load()
    love.window.setMode(800, 600, { resizable = true, vsync = true })
    love.window.setTitle("NoLove2D Game")

    player.image = love.graphics.newImage("Assets/Images/NL2D_Player.png")
    enemyImage  = love.graphics.newImage("Assets/Images/NL2D_Enemy_alt.png")

    for i = 1, 5 do
        table.insert(enemies, {
            x = math.random(100, 700),
            y = math.random(100, 500),
            width = 32,
            height = 50,
            speed = 50,
            image = enemyImage
        })
    end
end

function love.update(dt)
    if not gameStarted then
        mainMenu.update(dt)
        if mainMenu.startGame then
            gameStarted = true
        end
        return
    end

    if love.keyboard.isDown("w") then
        player.y = player.y - player.speed * dt
    elseif love.keyboard.isDown("s") then
        player.y = player.y + player.speed * dt
    end
    if love.keyboard.isDown("a") then
        player.x = player.x - player.speed * dt
    elseif love.keyboard.isDown("d") then
        player.x = player.x + player.speed * dt
    end

    player.x = math.max(0, math.min(player.x, love.graphics.getWidth() - player.width))
    player.y = math.max(0, math.min(player.y, love.graphics.getHeight() - player.height))

    for _, enemy in ipairs(enemies) do
        local dx = player.x - enemy.x
        local dy = player.y - enemy.y
        local dist = math.sqrt(dx * dx + dy * dy)
        if dist > 0 then
            enemy.x = enemy.x + (dx / dist) * enemy.speed * dt
            enemy.y = enemy.y + (dy / dist) * enemy.speed * dt
        end

        if checkCollision(player, enemy) then
            if not collided then
                print("Collision with enemy!")
                score = score + 1
                collided = true
            end
        else
            collided = false
        end
    end
end

function love.draw()
    if not gameStarted then
        mainMenu.draw()
        return
    end

    love.graphics.setColor(0, 0, 1)
    love.graphics.printf("Score: " .. score, 30, 20, love.graphics.getWidth(), "left")

    if player.image then
        local scaleX = player.width / player.image:getWidth()
        local scaleY = player.height / player.image:getHeight()
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(
            player.image,
            player.x + player.width / 2,
            player.y + player.height / 2,
            0,
            scaleX,
            scaleY,
            player.image:getWidth() / 2,
            player.image:getHeight() / 2
        )
    else
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
    end

    for _, enemy in ipairs(enemies) do
        if enemy.image then
            local scaleX = enemy.width / enemy.image:getWidth()
            local scaleY = enemy.height / enemy.image:getHeight()
            
            love.graphics.draw(
                enemy.image,
                enemy.x + enemy.width / 2,
                enemy.y + enemy.height / 2,
                0,
                scaleX,
                scaleY,
                enemy.image:getWidth() / 2,
                enemy.image:getHeight() / 2
            )
        else
            love.graphics.setColor(1, 0, 0)
            love.graphics.rectangle("fill", enemy.x, enemy.y, enemy.width, enemy.height)
        end
    end
end

function checkCollision(a, b)
    return  a.x < b.x + b.width and
            b.x < a.x + a.width and
            a.y < b.y + b.height and
            b.y < a.y + a.height
end

function love.keypressed(key)
    if not gameStarted then
        mainMenu.keypressed(key)
    elseif key == "escape" then
        love.event.quit()
    end
end

local love_errorhandler = love.errorhandler
function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end

