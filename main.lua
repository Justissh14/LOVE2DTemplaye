if arg[2] == "debug" then
    require("lldebugger").start()
end




print("Hello World!");

function love.load()
    -- ThiS the name of window
    love.window.setTitle("Prototype-Game!")
    love.window.setMode(800, 600, {resizable=true, vsync=true})
    love.graphics.setBackgroundColor(0, 0, 200)
end

function love.update(dt)
end

function love.draw()
    love.graphics.print("THis is a test!", 350, 300)
    love.graphics.setColor(150, 0, 255, 255)
    print("Text printed successfully!")
end



--{sits at the bottom of the script}--
local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end