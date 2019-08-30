function love.load()

    cellSize = 12
    timer = 0
    timerLimit = 0.1

    gridXCount = math.floor(love.graphics.getWidth()/cellSize + 0.5)
    gridYCount = math.floor(love.graphics.getHeight()/cellSize + 0.5)
    love.graphics.setBackgroundColor(25/255, 30/255, 35/255)

    -- Maybe need random names in future
    function RandomVariable(length)
    	local res = ""
    	for i = 1, length do
    		res = res .. string.char(math.random(97, 122))
    	end
    	return res
    end

    -- Cell Drawing Function
    function drawCell(x, y)
        love.graphics.rectangle(
            'fill',
            (x - 1) * cellSize,
            (y - 1) * cellSize,
            cellSize - 1,
            cellSize - 1
        )
    end

    -- Player Class
    Player = {}
    Player.__index = Player
    function Player:Create()
        local this =
        {
            x = math.floor(gridXCount/2),
            y = math.floor(gridYCount/2),
            c1 = 0,
            c2 = 0,
            c3 = 1,
            name = RandomVariable(9),
            alive = true,
            directionQueue = 'left',
        }
        setmetatable(this, Player)
        return this
    end

    function Player:WarCry()
        print(self.name .. ": GRAAAHH!!!")
    end

    -- Draw Player
    function Player:Animate()
        love.graphics.setColor(self.c1, self.c2, self.c3)
        drawCell(self.x,self.y)
    end

--------------------------------------------------------------------------------

    -- Board Class
    Board = {}
    Board.__index = Board
    function Board:Create()
        local this =
        {
            grid = {},
            c1 = math.random(),
            c2 = math.random(),
            c3 = math.random(),
        }
        setmetatable(this, Board)
        return this
    end

    -- Clear Board
    function Board:Clear()
        for y = 1, gridYCount do
            self.grid[y] = {}
            for x = 1, gridXCount do
                self.grid[y][x] = 0
            end
        end
    end

    -- Grid Background
    function Board:Animate()
        for y = 1, gridYCount do
            for x = 1, gridXCount do
                local cellDrawSize = cellSize - 1
                --if self.grid[y][x] then
                --    love.graphics.setColor(self.c1, self.c2, self.c3)
                --else
                    love.graphics.setColor(35/255, 40/255, 45/255)
                --end
                love.graphics.rectangle(
                    'fill',
                    (x - 1) * cellSize,
                    (y - 1) * cellSize,
                    cellDrawSize,
                    cellDrawSize
                )
            end
        end
    end

--------------------------------------------------------------------------------

    player = Player:Create()
    board = Board:Create()
    board:Clear()
end

function love.update(dt)
    timer = timer + dt
    if player.alive then
        -- Handle Frames
        if timer >= timerLimit then
            -- Handle Game Speed
            timer = timer - timerLimit
        end

    elseif timer >= 2 then
        
    end
end

function love.draw()

    board.Animate()
    player.Animate()

end

-- Player Controls
function love.keypressed(key)
    if key == 'right' then
        player.x = player.x + 1
    elseif key == 'left' then
        player.x = player.x - 1
    elseif key == 'up' then
        player.y = player.y + 1
    elseif key == 'down' then
        player.y = player.y - 1
    elseif key == 'q' then
        timerLimit = timerLimit + 0.005
    elseif key == 'w' then
        timerLimit = timerLimit - 0.005
    elseif key == 'e' then
        timerLimit = 0.1
    end
end
