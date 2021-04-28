Ball = Class{}

function Ball:init(x, y, width, height) 
    self.x = x 
    self.y = y 
    self.width = width 
    self.height = height 
    -- velocity too
    self.dx = math.random(2) == 1 and -100 or 100 
    self.dy = math.random(-50,50)
end

function Ball:reset()
    self.x = VIRTUAL_WIDTH/2 - self.width/2
    self.y = VIRTUAL_HEIGHT/2 - self.height/2
    self.dx = math.random(2) == 1 and -100 or 100 
    self.dy = math.random(-50,50)
end

function Ball:collides(paddle)
    if self.x > paddle.x + paddle.width or self.x + self.width < paddle.x then 
        return false
    end

    if self.y > paddle.y + paddle.height or self.y + self.height < paddle.y then 
        return false
    end

    return true
end

function Ball:update(dt)
    newY = self.y + self.dy*dt
    -- newX = self.x + self.dx*dt
    if newY < 0 or newY > VIRTUAL_HEIGHT-self.height then
        self.dy = -self.dy
    end
    -- if newX < 0 or newX > VIRTUAL_WIDTH-self.width then
    --     self.dx = -self.dx
    -- end
    self.y = self.y + self.dy * dt
    self.x = self.x + self.dx * dt
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end