

local enemy = {}

enemy.enemies = {}  


function enemy.spawnEnemies(player)
    enemy.enemies = {}
    local enemyImage = love.graphics.newImage("Assets/Images/NL2D_Enemy_alt.png")
    local minDistance = 100  

    for i = 1, 10 do
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

        table.insert(enemy.enemies, {
            x = ex,
            y = ey,
            width = 32,
            height = 50,
            speed = 25,
            image = enemyImage,
            touched = false,  
        })
    end
end

local function checkCollision(player, e)
    return player.x < e.x + e.width and
           player.x + player.width > e.x and
           player.y < e.y + e.height and
           player.y + player.height > e.y
end

function enemy.update(dt, player, onCollision)
    for _, e in ipairs(enemy.enemies) do
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
                onCollision()  
            end
        else
            e.touched = false  
        end
    end
end

function enemy.draw()
    for _, e in ipairs(enemy.enemies) do
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(e.image, e.x, e.y, 0, e.width / e.image:getWidth(), e.height / e.image:getHeight())
    end
end

return enemy
