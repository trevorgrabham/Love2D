Class = require 'class'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

function love.load()
    love.window.setTitle('Flappy Bird')
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {fullscreen=false, resizable=false, vsync=true})
end

function love.update(dt)

end

function love.keypressed(key)
    if key == 'escape' then 
        love.event.quit()
    end
end

function love.draw()
    love.graphics.clear()
    love.graphics.printf('Welcome to Flappy Bird', 0, WINDOW_HEIGHT/2 - 6, WINDOW_WIDTH, 'center')
end
