
local mainMenu = {}

function mainMenu.load()
    mainMenu.startGame = false
end

function mainMenu.update(dt)
    -- Placeholder: Add menu animations or selection logic here
end

function mainMenu.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Press ENTER to Start", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
end

function mainMenu.keypressed(key)
    if key == "return" then
        mainMenu.startGame = true
    end
end

return mainMenu
