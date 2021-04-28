push = require 'push'
Class = require 'class'
require 'Paddle'
require 'Ball'


WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
    love.window.setTitle('Pong')

    love.graphics.setDefaultFilter('nearest','nearest')

    math.randomseed(os.time())

    legendFont = love.graphics.newFont('Fonts/ARCADECLASSIC.ttf', 20)
    promptFont = love.graphics.newFont('Fonts/ARCADECLASSIC.ttf', 14)
    scoreFont = love.graphics.newFont('Fonts/ARCADECLASSIC.ttf', 45)

    love.graphics.setFont(legendFont) 

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    player1Score = 0
    player2Score = 0

    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH-10, VIRTUAL_HEIGHT-30, 5, 20)

    ball = Ball(VIRTUAL_WIDTH/2 - 2, VIRTUAL_HEIGHT/2 - 2, 4, 4)

    gameState = 'start'

end

function love.update(dt)
    if gameState ~= 'paused' then 
        -- player 1
        if love.keyboard.isDown('w') then 
            player1.dy = -PADDLE_SPEED
            player1:update(dt)
        elseif love.keyboard.isDown('s') then 
            player1.dy = PADDLE_SPEED
            player1:update(dt)
        end

        -- player 2
        if love.keyboard.isDown('up') then 
            player2.dy = -PADDLE_SPEED
            player2:update(dt)
        elseif love.keyboard.isDown('down') then 
            player2.dy = PADDLE_SPEED
            player2:update(dt)
        end

        if gameState == 'play' then
            ball:update(dt)
        end
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'space' then
        if gameState == 'start' or gameState == 'paused' then
            gameState = 'play'
        elseif gameState == 'play' then
            gameState = 'paused'
        end
    end
end

function love.draw()

    push:apply('start')

    love.graphics.clear(40/255, 45/255, 52/255, 1)

    -- -- Legend
    -- love.graphics.setFont(legendFont)
    -- love.graphics.printf('Pong', 0, 20, VIRTUAL_WIDTH, 'center')

    -- Score
    love.graphics.setFont(scoreFont)
    love.graphics.printf(tostring(player1Score), 0, 10, VIRTUAL_WIDTH/2, 'center')
    love.graphics.printf(tostring(player2Score), VIRTUAL_WIDTH/2, 10, VIRTUAL_WIDTH/2, 'center')

    -- Game State
    love.graphics.setFont(promptFont)
    love.graphics.printf(gameState, 4, 0, 60, 'left')

    -- FPS
    love.graphics.setFont(promptFont)
    love.graphics.printf(love.timer.getFPS() .. '\tfps', VIRTUAL_WIDTH-64, 0, 60, 'right')

    -- Start Prompt
    if gameState == 'start' then 
        love.graphics.setFont(promptFont)
        love.graphics.printf('Press\tspace\tto\tstart', 0, VIRTUAL_HEIGHT/2 - 7, VIRTUAL_WIDTH, 'center')
    end

    -- Pause Screen
    if gameState == 'paused' then
        love.graphics.setFont(promptFont)
        love.graphics.printf('Press\tspace\tto\tresume', 0, VIRTUAL_HEIGHT/2 - 7, VIRTUAL_WIDTH, 'center')
    end

    -- Left Paddle
    player1:render()

    -- Right Paddle
    player2:render()

    -- Ball
    if gameState == 'play' or gameState == 'paused' then
        ball:render()
    end

    push:apply('end')
end


    