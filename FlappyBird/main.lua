Class = require 'class'
push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

require 'Bird'
require 'Pipe'
require 'PipePair'


local background = love.graphics.newImage('/Imgs/backgroundv2.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('/Imgs/ground.png')
local groundScroll = 0

local BACKGROUND_SPEED = 30
local GROUND_SPEED = BACKGROUND_SPEED * 2
local BACKGROUND_LOOPING_POINT = 568
local GROUND_LOOPING_POINT = 514

local bird = Bird()

local pipePairs = {}

local pipeTimer = 2



function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Flappy Bird')

    math.randomseed(os.time())

    smallFont = love.graphics.newFont('/Fonts/Orbitron-Medium.ttf', 10)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {fullscreen=false, resizable=true, vsync=true})

    love.keyboard.keysPressed = {}
end



function love.resize(w,h)
    push.resize(w,h)
end



function love.update(dt)
    backgroundScroll = (backgroundScroll + BACKGROUND_SPEED * dt) % BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SPEED*dt) % GROUND_LOOPING_POINT


    pipeTimer = pipeTimer + dt

    if pipeTimer > 3 then 
        table.insert(pipePairs, PipePair())
        pipeTimer = 0
    end


    bird:update(dt)

    for i, pipePair in pairs(pipePairs) do 
        if bird:collides(pipePair.pipes['top']) or bird:collides(pipePair.pipes['bottom']) then 
            gameState = 'game over'
        end
        pipePair:update(dt)
    end

    for i, pipePair in pairs(pipePairs) do 
        if pipePair.remove then
            table.remove(pipePairs, i)
        end
    end


    love.keyboard.keysPressed = {}
end



function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then 
        love.event.quit()
    end
end



function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end



function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)

    for i, pipePair in pairs(pipePairs) do 
        pipePair:render()
    end

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT-16)

    -- FPS
    love.graphics.setFont(smallFont)
    love.graphics.printf(love.timer.getFPS() .. ' FPS', 4, 4, 45, 'left')

    if gameState == 'game over' then 
        love.graphics.setFont(smallFont)
        love.graphics.printf('game over', VIRTUAL_WIDTH-54, 4, 50, 'right')
    end

    -- Bird
    bird:render()


    push:finish()
end
