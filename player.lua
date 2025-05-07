local Player = {}
local Bullet = require("bullet")
Player.__index = Player

function Player:new()
    local self = setmetatable({}, Player)
    self.x = 100
    self.y = 100
    self.width = 32
    self.height = 50
    self.speed = 200
    self.image = love.graphics.newImage("Assets/Images/NL2D_Player.png")
    self.Bullets = {}
    return self
end

function Player:Shoot(up, down, left, right)
    local bullet = Bullet(self.x,self.y, up, down, left, right)
    table.insert(self.Bullets, bullet)
end

function Player:update(dt)
    if love.keyboard.isDown("w") then self.y = self.y - self.speed * dt end
    if love.keyboard.isDown("s") then self.y = self.y + self.speed * dt end
    if love.keyboard.isDown("a") then self.x = self.x - self.speed * dt end
    if love.keyboard.isDown("d") then self.x = self.x + self.speed * dt end

    for i = #self.Bullets, 1, -1 do
            local value = self.Bullets[i]
            value:update(dt)
        if value.x < 0 or value.x + value.width > love.graphics.getWidth() or value.y < 0 or value.y +value.height > love.graphics.getHeight() then
            table.remove(self.Bullets, i)
        end
    end

    self.x = math.max(0, math.min(self.x, love.graphics.getWidth() - self.width))
    self.y = math.max(0, math.min(self.y, love.graphics.getHeight() - self.height))
end

function Player:draw()
    for index, value in ipairs(self.Bullets) do
        value:draw()
        end
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

