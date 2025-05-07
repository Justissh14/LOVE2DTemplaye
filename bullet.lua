Object = require("Classic")
bullet = Object:extend()

function bullet:new()
    self.image = love.graphics.newImage("Assets/Images/NL2D_bullet.png")
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.speed = 500

end

function bullet:update(dt)
    if love.keyboard.isDown("up") then bullet.y = bullet.y - bullet.speed * dt end
    
    if love.keyboard.isDown("up") and love.keyboard.isDown("left")  then
        
    end
    if love.keyboard.isDown("up") and love.keyboard.isDown("right") then 


    end
    if love.keyboard.isDown("down") then bullet.y = bullet.y + bullet.speed * dt end

    if love.keyboard.isDown("down") and love.keyboard.isDown("left") then
    
    end

    if love.keyboard.isDown("down") and love.keyboard.isDown("right") then
    
    end
    
    if love.keyboard.isDown("left") then bullet.x = bullet.x - bullet.speed * dt end

    if love.keyboard.isDown("right") then bullet.x = bullet.x + bullet.speed * dt end
end

function bullet:draw()
    love.graphics.draw(self.image)
end
