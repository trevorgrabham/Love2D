GameOverState = Class{__includes = BaseState}

function GameOverState:enter(params)
    self.score = params.score 
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then 
        gStateMachine:change('countdown')
    end
end

function GameOverState:render()
    love.graphics.setFont(largeFont)
    love.graphics.setColor(0,0,0,1)
    love.graphics.printf('GAME OVER\nSCORE: ' .. self.score, 0, VIRTUAL_HEIGHT/2-30, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press Enter to play again', 0, 3*VIRTUAL_HEIGHT/4, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1,1,1,1)
end