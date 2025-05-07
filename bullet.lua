Object = require("Classic")
local bullet = Object:extend()

function bullet:new(x,y, up, down, left, right)
    self.image = love.graphics.newImage("Assets/Images/NL2D_bullet.png")
    self.x = x
    self.y = y
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.speed = 5000
    self.up = false
    self.left = false
    self.down = false
    self.right = false

end

function bullet:update(dt)
    if love.keyboard.isDown("up") then self.y = self.y - self.speed * dt end
    
    if love.keyboard.isDown("up") and love.keyboard.isDown("left")  then
        self.y = self.y - self.speed * dt
        self.x = self.x - self.speed * dt
    end
    if love.keyboard.isDown("up") and love.keyboard.isDown("right") then 
        self.y = self.y - self.speed * dt
        self.x = self.x + self.speed * dt

    end
    if love.keyboard.isDown("down") then self.y = self.y + self.speed * dt end

    if love.keyboard.isDown("down") and love.keyboard.isDown("left") then
        self.y = self.y + self.speed * dt
        self.x = self.x - self.speed * dt

    end

    if love.keyboard.isDown("down") and love.keyboard.isDown("right") then
        self.y = self.y + self.speed * dt
        self.x = self.x + self.speed * dt

    end
    
    if love.keyboard.isDown("left") then self.x = self.x - self.speed * dt end

    if love.keyboard.isDown("right") then self.x = self.x + self.speed * dt end
end

function bullet:draw()
    love.graphics.draw(self.image, self.x, self.y)
end
return bullet