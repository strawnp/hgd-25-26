PipePair = Class{}

local GAP_HEIGHT = 90

function PipePair:init(y)
    self.x = VIRTUAL_WIDTH + 32
    self.y = y

    -- TODO: finish implementing constructor
    self.pipes = {
        ['upper'] = Pipe('top', ???),
        ['lower'] = Pipe('bottom', ???)
    }

    self.remove = ???
    self.scored = ???
end

function PipePair:update(dt)
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end