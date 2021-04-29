Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('Imgs/pipe.png')

local SCROLL_SPEED = -60


function Pipe:init(isBottom, y)
    self.x = VIRTUAL_WIDTH
    self.y = y
    self.width = PIPE_IMAGE:getWidth()
    if isBottom then 
        self.yScale = 1
    else
        self.yScale = -1
    end
end

function Pipe:update(dt)
    self.x = self.x + SCROLL_SPEED * dt
end


function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, self.y, 0, 1, self.yScale)
end
