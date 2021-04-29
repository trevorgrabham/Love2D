PipePair = Class{}

local GAP_HEIGHT = 90

-- these are used to calculate the y value of the bottom pipe
local previousHeight = 2*VIRTUAL_HEIGHT/5
local minHeight = 0
local maxHeight = 0

function PipePair:init()
    minHeight = math.max(previousHeight-VIRTUAL_HEIGHT/3, 50)
    maxHeight = math.min(previousHeight+VIRTUAL_HEIGHT/3, 3*VIRTUAL_HEIGHT/5)
    previousHeight = VIRTUAL_HEIGHT - math.random(minHeight, maxHeight)
    self.pipes = {
        ['top'] = Pipe(false, previousHeight - GAP_HEIGHT),
        ['bottom'] = Pipe(true, previousHeight)
    }
    self.remove = false
end

function PipePair:render()
    self.pipes['top']:render()
    self.pipes['bottom']:render()
end

function PipePair:update(dt)
    self.pipes['top']:update(dt)
    self.pipes['bottom']:update(dt)
    if self.pipes['bottom'].x + self.pipes['bottom'].width < 0 then
        self.remove = true 
    end
end