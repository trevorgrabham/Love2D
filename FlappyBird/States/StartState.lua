StartState = Class{__includes = BaseState}

function StartState:update(dt)
    if love.keyboard.wasPressed('space') then 
        gStateMachine:change('countdown')
    end
end

function StartState:render()
    love.graphics.setFont(titleFont)
    love.graphics.printf('Flappy Bird', 0, VIRTUAL_HEIGHT/2-30, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press Space to start', 0, VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH, 'center')
end