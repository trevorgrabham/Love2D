PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.pipeTimer = 3
    self.score = 0
end

function PlayState:update(dt)
    self.pipeTimer = self.pipeTimer + dt

    if self.pipeTimer > 3 then 
        table.insert(self.pipePairs, PipePair())
        self.pipeTimer = 0
    end

    self.bird:update(dt)
    if self.bird:outOfBounds() then 
        gStateMachine:change('game over', {score = self.score})
    end


    for i, pipePair in pairs(self.pipePairs) do 
        if self.bird:collides(pipePair.pipes['top']) or self.bird:collides(pipePair.pipes['bottom']) then 
            gStateMachine:change('game over', {score = self.score})
        end
        if not pipePair.scored then  
            if pipePair.pipes['bottom'].x + pipePair.pipes['bottom'].width < self.bird.x then 
                self.score = self.score + 1
                pipePair.scored = true
            end
        end
        pipePair:update(dt)
    end

    for i, pipePair in pairs(self.pipePairs) do 
        if pipePair.remove then 
            table.remove(self.pipePairs, i)
        end
    end
end

function PlayState:render()
    for i, pipePair in pairs(self.pipePairs) do 
        pipePair:render()
    end

    self.bird:render()

    love.graphics.setFont(smallFont)
    love.graphics.printf(tostring(self.score), VIRTUAL_WIDTH - 30, 4, 26, 'right')
end

