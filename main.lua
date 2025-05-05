
if arg[2] == "debug" then
    require("lldebugger").start()
end


player = { x = 100, y = 100, speed = 200, radius = 10 }
enemy  = { x = 300, y = 300, speed = 100, radius = 10 }

local collided = false

function love.update(dt)
    if love.keyboard.isDown("up") then
        player.y = player.y - player.speed * dt
    elseif love.keyboard.isDown("down") then
        player.y = player.y + player.speed * dt
    end
    if love.keyboard.isDown("left") then
        player.x = player.x - player.speed * dt
    elseif love.keyboard.isDown("right") then
        player.x = player.x + player.speed * dt
    end

    local dx = player.x - enemy.x
    local dy = player.y - enemy.y
    local dist = math.sqrt(dx*dx + dy*dy)

    if dist > 0 then
        enemy.x = enemy.x + (dx / dist) * enemy.speed * dt
        enemy.y = enemy.y + (dy / dist) * enemy.speed * dt
    end

    -- collision check
    local collisionDistance = player.radius + enemy.radius
    if dist <= collisionDistance then
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
    love.graphics.circle("fill", player.x, player.y, player.radius)

    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", enemy.x, enemy.y, enemy.radius)
end


local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end