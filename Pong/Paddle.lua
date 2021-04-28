Paddle = Class{}

function Paddle:init(x, y, width, height)
    self.x = x 
    self.y = y 
    self.width = width 
    self.height = height
    self.dy = 0
end

function Paddle:update(dt)
    if self.dy > 0 then 
        self.y = math.min(self.y + self.dy*dt, VIRTUAL_HEIGHT-self.height)
    else  
        self.y = math.max(self.y + self.dy*dt, 0)
    end
end

function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

    