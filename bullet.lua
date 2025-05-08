local Object = require("Classic")
local bullet = Object:extend()

function bullet:new(x, y, dirX, dirY)
    self.image = love.graphics.newImage("Assets/Images/NL2D_bullet.png")
    self.x = x
    self.y = y
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.speed = 500
    self.dirX = dirX
    self.dirY = dirY
end

function bullet:update(dt)
    self.x = self.x + self.dirX * self.speed * dt
    self.y = self.y + self.dirY * self.speed * dt
end

function bullet:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

return bullet

