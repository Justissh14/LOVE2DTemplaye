
if arg[2] == "debug" then
    require("lldebugger").start()
end



player = { x = 100, y = 100, width = 32, height = 50, speed = 200 }
enemy  = { x = 300, y = 300, width = 32, height = 50, speed = 100 }

local collided = false

function love.update(dt)
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

    local dx = player.x - enemy.x
    local dy = player.y - enemy.y
    local dist = math.sqrt(dx * dx + dy * dy)
    if dist > 0 then
        enemy.x = enemy.x + (dx / dist) * enemy.speed * dt
        enemy.y = enemy.y + (dy / dist) * enemy.speed * dt
    end

    -- collision check
    if checkCollision(player, enemy) then
        if not collided then
            print("Collision detected!")
            collided = true
        end
    else
        collided = false
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)

    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", enemy.x, enemy.y, enemy.width, enemy.height)
end

function checkCollision(a, b)
    return  a.x < b.x + b.width and
            b.x < a.x + a.width and
            a.y < b.y + b.height and
            b.y < a.y + a.height
end



local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end