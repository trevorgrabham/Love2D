Class = require 'class'
push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

require 'Bird'
require 'Pipe'
require 'PipePair'
require 'StateMachine'
require 'States/BaseState'
require 'States/PlayState'
require 'States/GameOverState'
require 'States/StartState'
require 'States/CountdownState'


local background = love.graphics.newImage('/Imgs/backgroundv2.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('/Imgs/ground.png')
local groundScroll = 0

local BACKGROUND_SPEED = 30
local GROUND_SPEED = BACKGROUND_SPEED * 2
local BACKGROUND_LOOPING_POINT = 568
local GROUND_LOOPING_POINT = 514

-- local bird = Bird()

-- local pipePairs = {}

-- local pipeTimer = 2

-- local score = 0



function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Flappy Bird')

    math.randomseed(os.time())

    smallFont = love.graphics.newFont('/Fonts/Orbitron-Medium.ttf', 10)
    mediumFont = love.graphics.newFont('/Fonts/Orbitron-Medium.ttf', 18)
    titleFont = love.graphics.newFont('/Fonts/Orbitron-Medium.ttf', 24)
    largeFont = love.graphics.newFont('/Fonts/Orbitron-Medium.ttf', 30)
    xlFont = love.graphics.newFont('/Fonts/Orbitron-Medium.ttf', 45)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {fullscreen=false, resizable=true, vsync=true})

    gStateMachine = StateMachine{
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['game over'] = function() return GameOverState() end,
        ['countdown'] = function() return CountdownState() end
    }
    gStateMachine:change('start')

    love.keyboard.keysPressed = {}
    -- gameState = 'start'
end



function love.resize(w,h)
    push.resize(w,h)
end



function love.update(dt)
    -- if gameState ~= 'start' and gameState ~= 'game over' then
        backgroundScroll = (backgroundScroll + BACKGROUND_SPEED * dt) % BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll + GROUND_SPEED*dt) % GROUND_LOOPING_POINT

        gStateMachine:update(dt)

        -- pipeTimer = pipeTimer + dt

        -- if pipeTimer > 3 then 
        --     table.insert(pipePairs, PipePair())
        --     pipeTimer = 0
        -- end


        -- bird:update(dt)
        -- if bird:outOfBounds() then 
        --     gameState = 'game over'
        -- end

        -- for i, pipePair in pairs(pipePairs) do 
        --     if bird:collides(pipePair.pipes['top']) or bird:collides(pipePair.pipes['bottom']) then 
        --         gameState = 'game over'
        --     end
        --     pipePair:update(dt)
        -- end

        -- for i, pipePair in pairs(pipePairs) do 
        --     if pipePair.remove then
        --         table.remove(pipePairs, i)
        --     end
        -- end


        love.keyboard.keysPressed = {}
    -- end
end



function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then 
        love.event.quit()
    end

    -- if key == 'space' then 
    --     if gameState == 'start' then 
    --         gameState = 'play'
    --     end
    -- end
end



function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end



function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)

    -- if gameState == 'play' then 
    --     for i, pipePair in pairs(pipePairs) do 
    --         pipePair:render()
    --     end
    -- end
    gStateMachine:render()

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT-16)


    -- if gameState == 'game over' then 
    --     love.graphics.setFont(largeFont)
    --     love.graphics.setColor(0,0,0,1)
    --     love.graphics.printf('GAME OVER\nSCORE: ' .. score, 0, VIRTUAL_HEIGHT/2-30, VIRTUAL_WIDTH, 'center')
    --     love.graphics.setColor(1,1,1,1)
    -- end

    -- love.graphics.setFont(smallFont)
    -- love.graphics.printf(tostring(score), VIRTUAL_WIDTH/2-30, 4, 50, 'right')

    -- Bird
    -- if gameState ~= 'game over' then 
    --     bird:render()
    -- end

    push:finish()
end
