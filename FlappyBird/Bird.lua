Bird = Class{}

local GRAVITY = 20

local JUMP_FORCE = -5

local BIRD_IMAGE = love.graphics.newImage('/Imgs/bird.png')


function Bird:init()
    self.image = BIRD_IMAGE
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.x = VIRTUAL_WIDTH/2 - self.width/2
    self.y = self.height * 3
    self.dy = 0
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