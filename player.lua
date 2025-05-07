--for all your player code justiss
local Player = {}
Player.__index = Player

function Player:new()
    local self = setmetatable({}, Player)
    self.x = 100
    self.y = 100
    self.width = 32
    self.height = 50
    self.speed = 200
    self.image = love.graphics.newImage("Assets/Images/NL2D_Player.png")
    return self
end

function Player:update(dt)
    if love.keyboard.isDown("w") then self.y = self.y - self.speed * dt end
    if love.keyboard.isDown("s") then self.y = self.y + self.speed * dt end
    if love.keyboard.isDown("a") then self.x = self.x - self.speed * dt end
    if love.keyboard.isDown("d") then self.x = self.x + self.speed * dt end

    self.x = math.max(0, math.min(self.x, love.graphics.getWidth() - self.width))
    self.y = math.max(0, math.min(self.y, love.graphics.getHeight() - self.height))
end

function Player:draw()
    if self.image then
        local scaleX = self.width / self.image:getWidth()
        local scaleY = self.height / self.image:getHeight()
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.image, self.x + self.width / 2, self.y + self.height / 2, 0, scaleX, scaleY,
            self.image:getWidth() / 2, self.image:getHeight() / 2)
    else
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    end
end

return Player

