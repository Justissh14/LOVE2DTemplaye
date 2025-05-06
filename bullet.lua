require("Classic")
Bullet = Object:extend()

function Bullet:new()
    self.image = love.graphics.newImage("bullet.png")
end

function Bullet:draw()
    love.graphics.draw(self.image)
end
