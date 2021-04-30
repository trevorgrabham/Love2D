Bird = Class{}

local GRAVITY = 20

local JUMP_FORCE = -5

local BIRD_IMAGE = love.graphics.newImage('/Imgs/bird.png')

local FORGIVENESS_PIXELS = 2


function Bird:init()
    self.image = BIRD_IMAGE
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.x = VIRTUAL_WIDTH/2 - self.width/2
    self.y = self.height * 3
    self.dy = 0
end


function Bird:collides(pipe)
    if self.x >= pipe.x -self.width + FORGIVENESS_PIXELS and self.x <= pipe.x + pipe.width - FORGIVENESS_PIXELS then 
        if self.x <= pipe.x - self.width/2 then 
            if math.abs(math.sqrt((self.x+self.width/2-pipe.x)*(self.x+self.width/2-pipe.x) + (self.y + self.height/2 - pipe.y)*(self.y + self.height/2 - pipe.y))) <= self.width/2 - 2*FORGIVENESS_PIXELS then 
                return true 
            end
        elseif self.x >= pipe.x + pipe.width - self.width/2 then 
            if math.abs(math.sqrt((self.x+self.width/2-pipe.x-pipe.width)*(self.x+self.width/2-pipe.x-pipe.width) + (self.y + self.height/2 - pipe.y)*(self.y + self.height/2 - pipe.y))) <= self.width/2 - 2*FORGIVENESS_PIXELS then 
                return true 
            end
        end
        if pipe.isBottom then 
            if self.y + self.height - FORGIVENESS_PIXELS >= pipe.y then 
                return true
            end
        else
            if self.y + FORGIVENESS_PIXELS <= pipe.y then
                return true
            end
        end
    end
    return false
end

function Bird:outOfBounds()
    return self.y < -FORGIVENESS_PIXELS or self.y + self.height > VIRTUAL_HEIGHT - 16 + FORGIVENESS_PIXELS
end


function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt
    self.y = self.y + self.dy 

    if love.keyboard.wasPressed('space') then 
        self.dy = JUMP_FORCE
    end
end

-- function Bird:jump(dt)
--     self.dy = self.dy - JUMP_FORCE * dt
--     if self.framesLeft >= 0 then 
--         self.framesLeft = self.framesLeft - 1
--     else
--         self.framesLeft = JUMP_FRAMES - 1
--     end
-- end


function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end