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
        resizable = true,
        vsync = true
    })

    player1Score = 0
    player2Score = 0

    winner = ''
    justScored = 0

    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH-10, VIRTUAL_HEIGHT-30, 5, 20)

    ball = Ball(VIRTUAL_WIDTH/2 - 2, VIRTUAL_HEIGHT/2 - 2, 4, 4)

    gameState = 'start'

end


function love.resize(w, h)
    push:resize(w,h)
end


function love.update(dt)
    if gameState ~= 'paused' and gameState ~= 'game over' then 

        if gameState ~= 'serve' then 
            -- handle collisions
            if ball:collides(player1) then 
                ball.dx = -ball.dx * 1.1
                -- move the ball just off of the player so that a collision isn't detected again
                ball.x = player1.x + player1.width       
                
                -- handle the y velocity
                if ball.dy > 0 then 
                    ball.dy = math.min(ball.dy + player1.dy/5, 150)
                else
                    ball.dy = math.max(ball.dy + player1.dy/5, -150)
                end
            end

            if ball:collides(player2) then 
                ball.dx = -ball.dx * 1.1
                -- move the ball just off of the player so that a collision isn't detected again
                ball.x = player2.x - ball.width        
                if ball.dy > 0 then 
                    ball.dy = math.min(ball.dy + player2.dy/5, 150)
                else
                    ball.dy = math.max(ball.dy + player2.dy/5, -150)
                end
            end


            -- handle the score
            if ball.x <= 0 then 
                player2Score = player2Score + 1
                justScored = 2
                if player2Score >= 10 then 
                    gameState = 'game over'
                    winner = 'Player\t2'
                else
                    ball:reset()
                    gameState = 'serve'
                end
            end
            if ball.x + ball.width >= VIRTUAL_WIDTH then 
                player1Score = player1Score + 1
                justScored = 1
                if player1Score >= 10 then 
                    gameState = 'game over'
                    winner = 'Player\t1'
                else
                    ball:reset()
                    gameState = 'serve'
                end
            end
        end


        -- player 1
        if love.keyboard.isDown('w') then 
            player1.dy = -PADDLE_SPEED
            player1:update(dt)
        elseif love.keyboard.isDown('s') then 
            player1.dy = PADDLE_SPEED
            player1:update(dt)
        else
            player1.dy = 0
        end

        -- player 2
        if love.keyboard.isDown('up') then 
            player2.dy = -PADDLE_SPEED
            player2:update(dt)
        elseif love.keyboard.isDown('down') then 
            player2.dy = PADDLE_SPEED
            player2:update(dt)
        else
            player2.dy = 0
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
        elseif gameState == 'game over' then 
            player1Score = 0
            player2Score = 0
            winner = ''
            gameState = 'start'
            ball:reset()
        elseif gameState == 'serve' then 
            if justScored == 1 then 
                ball.dx = -100
                ball.x = player2.x - ball.width
                ball.y = player2.y + player2.height/2 - ball.height/2
            elseif justScored == 2 then 
                ball.dx = 100
                ball.x = player1.x + player1.width
                ball.y = player1.y + player1.height/2 - ball.height/2
            end
            gameState = 'play'
        end
    elseif key == 'return' then 
        ball:reset()
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

    -- Game over screen
    if gameState == 'game over' then 
        love.graphics.setFont(promptFont)
        love.graphics.printf(winner .. '\twon', 0, VIRTUAL_HEIGHT/2 -7, VIRTUAL_WIDTH, 'center')
    end

    -- Serve screen
    if gameState == 'serve' then 
        love.graphics.setFont(promptFont)
        love.graphics.printf('Player\t'..justScored%2 + 1 .. '\tto\tserve', 0, VIRTUAL_HEIGHT/2 -7, VIRTUAL_WIDTH, 'center')
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


    