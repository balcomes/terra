function love.load()

    cellSize = 12
    timer = 0
    timerLimit = 0.1

    water_table = {}
    dirt_table = {}
    sand_table = {}
    grass_table = {}
    stone_table = {}
    lava_table = {}
    tree_table = {}

    gridXCount = math.floor(love.graphics.getWidth()/cellSize + 0.5)
    gridYCount = math.floor(love.graphics.getHeight()/cellSize + 0.5)
    love.graphics.setBackgroundColor(25/255, 30/255, 35/255)

    function spread(g,x,y,n)
        local tally = 0
        if g[y-1][x-1] == n then
            tally = tally + 1
        end
        if g[y-1][x] == n then
            tally = tally + 1
        end
        if g[y-1][x+1] == n then
            tally = tally + 1
        end
        if g[y][x-1] == n  then
            tally = tally + 1
        end
        if g[y][x+1] == n then
            tally = tally + 1
        end
        if g[y+1][x-1] == n then
            tally = tally + 1
        end
        if g[y+1][x] == n then
            tally = tally + 1
        end
        if g[y+1][x+1]== n then
            tally = tally + 1
        end
        return tally
    end

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

    -- Respawn Player
function reset()
    player = Player:Create()
end

--------------------------------------------------------------------------------
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
            c3 = 0,
            name = RandomVariable(9),
            alive = true,
        }
        setmetatable(this, Player)
        return this
    end

    -- Player Animate
    function Player:Animate()
        love.graphics.setColor(self.c1, self.c2, self.c3)
        drawCell(self.x, self.y)
    end

    -- Player Drown
    function Player:Drown()
        if board.grid[self.y-1][self.x] == "water"
            and board.grid[self.y][self.x-1] == "water"
            and board.grid[self.y][self.x+1] == "water"
            and board.grid[self.y+1][self.x] == "water" then
                self.alive = false
        end
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

    -- Board Animate
    function Board:Animate()
        for y = 1, gridYCount do
            for x = 1, gridXCount do
                local cellDrawSize = cellSize - 1
                -- Water
                if self.grid[y][x] == "water" then
                    if math.random() < .05 then
                        love.graphics.setColor(100/255, 100/255, math.random(200/255,255/255))
                    else
                        love.graphics.setColor(100/255, 100/255, 200/255)
                    end
                end
                if self.grid[y][x] == "lava" then
                    if math.random() < .1 then
                        love.graphics.setColor(math.random(200/255,255/255), 100/255, 100/255)
                    else
                        love.graphics.setColor(200/255, 100/255, 100/255)
                    end
                end
                if self.grid[y][x] == "sand" then
                    love.graphics.setColor(200/255, 200/255, 200/255)
                end
                if self.grid[y][x] == "dirt" then
                    love.graphics.setColor(200/255, 200/255, 100/255)
                end
                if self.grid[y][x] == "grass" then
                    love.graphics.setColor(100/255, 200/255, 100/255)
                end
                if self.grid[y][x] == "stone" then
                    love.graphics.setColor(100/255, 100/255, 100/255)
                end
                if self.grid[y][x] == "tree" then
                    love.graphics.setColor(100/255, 200/255, 100/255)
                end
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

    -- Board Water Fill
    function Board:Clear()
        for y = 1, gridYCount do
            self.grid[y] = {}
            for x = 1, gridXCount do
                self.grid[y][x] = "water"
            end
        end
    end

    -- Board Island Fill
    function Board:Fill()
        for y = 10, gridYCount - 10 do
            for x = 10, gridXCount -10 do
                self.grid[y][x] = "dirt"
            end
        end
    end

    -- Board Erode
    function Board:Erode()

        for k,v in  pairs(lava_table) do
            self.grid[v.y][v.x] = "lava"
        end

        for y = 2, gridYCount - 1 do

            for x = 2, gridXCount - 1 do

                -- Dirt to Sand
                if self.grid[y][x] == "dirt" then
                    dirt_water = spread(self.grid,x,y,"water")
                    if math.random() < dirt_water/80 then
                        self.grid[y][x] = "sand"
                    end
                end

                -- Sand to Water
                if self.grid[y][x] == "sand" then
                    sand_water = spread(self.grid,x,y,"water")
                    if math.random() < sand_water/2000 then
                        self.grid[y][x] = "water"
                    end
                end

                -- Grass to Dirt
                if self.grid[y][x] == "grass" then
                    grass_water = spread(self.grid,x,y,"water")
                    grass_sand = spread(self.grid,x,y,"sand")
                    if math.random() < grass_water*grass_sand then
                        self.grid[y][x] = "dirt"
                    end
                end

                -- Dirt to Grass
                if self.grid[y][x] == "dirt" then
                    dirt_grass = spread(self.grid,x,y,"grass")
                    dirt_sand = spread(self.grid,x,y,"sand")
                    if math.random() < dirt_grass*dirt_sand/2000 + .001 then
                        self.grid[y][x] = "grass"
                    end
                end

                -- Grass to Tree
                if self.grid[y][x] == "grass" then
                    dirt_grass = spread(self.grid,x,y,"grass")
                    dirt_sand = spread(self.grid,x,y,"sand")
                    if math.random() < dirt_grass*dirt_sand/1000 + .0001 then
                        table.insert(tree_table,Tree:Create(x,y))
                        self.grid[y][x] = "tree"
                    end
                end

                -- Lava to Dirt
                if self.grid[y][x] == "lava" then
                    if math.random() < .1 then
                        self.grid[y][x] = "dirt"
                    end
                end

                -- Spread Lava
                if self.grid[y][x] ~= "stone" or self.grid[y][x] ~= "lava" then
                    any_lava = spread(self.grid,x,y,"lava")
                    if self.grid[y][x] == "water" then
                        water_lava = spread(self.grid,x,y,"lava")
                        if math.random() < any_lava/100 then
                            self.grid[y][x] = "lava"
                        end
                    elseif math.random() < any_lava/100 then
                        if math.random() < 0.1 then
                            table.insert(stone_table, Stone:Create(x,y,1))
                            self.grid[y][x] = "stone"
                        else
                            self.grid[y][x] = "lava"
                        end
                    end
                end

                -- Trample Grass
                if self.grid[player.y][player.x] == "grass" then
                    self.grid[player.y][player.x] = "dirt"
                end

            end
        end
    end

--------------------------------------------------------------------------------
    -- Water Class
    Water = {}
    Water.__index = Water
    function Water:Create(xo,yo,c)
        local this =
        {
            x = xo,
            y = yo,
            c1 = 0.5,
            c2 = 0.5,
            c3 = 0.5,
        }
        board.grid[this.y][this.x] = "stone"
        setmetatable(this, Water)
        return this
    end

    -- Water Animate
    function Water:Animate()
        love.graphics.setColor(self.c1, self.c2, self.c3)
        drawCell(self.x, self.y)
    end
--------------------------------------------------------------------------------
    -- Dirt Class
    Dirt = {}
    Dirt.__index = Dirt
    function Dirt:Create(xo,yo,c)
        local this =
        {
            x = xo,
            y = yo,
            c1 = 0.5,
            c2 = 0.5,
            c3 = 0.5,
        }
        board.grid[this.y][this.x] = "stone"
        setmetatable(this, Dirt)
        return this
    end

    -- Dirt Animate
    function Dirt:Animate()
        love.graphics.setColor(self.c1, self.c2, self.c3)
        drawCell(self.x, self.y)
    end
--------------------------------------------------------------------------------
    -- Sand Class
    Sand = {}
    Sand.__index = Sand
    function Sand:Create(xo,yo,c)
        local this =
        {
            x = xo,
            y = yo,
            c1 = 0.5,
            c2 = 0.5,
            c3 = 0.5,
        }
        board.grid[this.y][this.x] = "stone"
        setmetatable(this, Sand)
        return this
    end

    -- Sand Animate
    function Sand:Animate()
        love.graphics.setColor(self.c1, self.c2, self.c3)
        drawCell(self.x, self.y)
    end
--------------------------------------------------------------------------------
    -- Grass Class
    Grass = {}
    Grass.__index = Grass
    function Grass:Create(xo,yo,c)
        local this =
        {
            x = xo,
            y = yo,
            c1 = 0.5,
            c2 = 0.5,
            c3 = 0.5,
        }
        board.grid[this.y][this.x] = "stone"
        setmetatable(this, Grass)
        return this
    end

    -- Grass Animate
    function Grass:Animate()
        love.graphics.setColor(self.c1, self.c2, self.c3)
        drawCell(self.x, self.y)
    end
--------------------------------------------------------------------------------
    -- Lava Class
    Lava = {}
    Lava.__index = Lava
    function Lava:Create(xo,yo,c)
        local this =
        {
            x = xo,
            y = yo,
            c1 = 1,
            c2 = math.random()/9,
            c3 = math.random()/9,
            conc = c,
            blink = true,
        }
        setmetatable(this, Lava)
        return this
    end

    -- Lava Animate
    function Lava:Animate()
        love.graphics.setColor(self.c1, self.c2, self.c3)
        if self.blink == true then
            self:Blink()
        end
        drawCell(self.x, self.y)
    end

    -- Lava Blink
    function Lava:Blink()
        self.c1 = math.random()/2 + 0.5
        self.c2 = math.random()/2
        self.c3 = math.random()/2
    end

--------------------------------------------------------------------------------

    -- Stone Class
    Stone = {}
    Stone.__index = Stone
    function Stone:Create(xo,yo,c)
        local this =
        {
            x = xo,
            y = yo,
            c1 = 0.5,
            c2 = 0.5,
            c3 = 0.5,
        }
        board.grid[this.y][this.x] = "stone"
        setmetatable(this, Stone)
        return this
    end

    -- Stone Animate
    function Stone:Animate()
        love.graphics.setColor(self.c1, self.c2, self.c3)
        drawCell(self.x, self.y)
    end

--------------------------------------------------------------------------------

-- Tree Class
Tree = {}
Tree.__index = Tree
function Tree:Create(xo,yo,c)
    local this =
    {
        x = xo,
        y = yo,
        c1 = 0.5,
        c2 = 0.5,
        c3 = 0.1,
        hp = 10,
    }
    board.grid[this.y][this.x] = "stone"
    setmetatable(this, Stone)
    return this
end

-- Tree Animate
function Tree:Animate()
    love.graphics.setColor(self.c1, self.c2, self.c3)
    drawCell(self.x, self.y)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

    board = Board:Create()
    board:Clear()
    board:Fill()
    reset()

    -- Add a Volcano
    table.insert(lava_table, Lava:Create(math.random(5, gridXCount - 5),
                                   math.random(5, gridYCount - 5),1))

end

--------------------------------------------------------------------------------

function love.update(dt)
    timer = timer + dt
    if player.alive then
        -- Handle Frames
        if timer >= timerLimit then
            -- Handle Game Speed
            timer = timer - timerLimit

            -- Plug with Stone
            for k,v in pairs(stone_table) do
                if board.grid[v.y][v.x] == "water" then
                    board.grid[v.y][v.x] = "dirt"
                    table.remove(stone_table,k)
                end
            end

            player:Drown()
            board:Erode()

            -- Player Movement
            if love.keyboard.isDown( "up" )
            and player.y > 2
            and board.grid[player.y - 1][player.x] ~= "water"
            and board.grid[player.y - 1][player.x] ~= "lava"
            and board.grid[player.y - 1][player.x] ~= "tree"
            and (board.grid[player.y - 1][player.x] ~= "stone" or board.grid[player.y - 2][player.x] ~= "stone") then
                player.y = player.y - 1
            end
            if love.keyboard.isDown( "down" )
            and player.y < gridYCount - 1
            and board.grid[player.y + 1][player.x] ~= "water"
            and board.grid[player.y + 1][player.x] ~= "lava"
            and board.grid[player.y + 1][player.x] ~= "tree"
            and (board.grid[player.y + 1][player.x] ~= "stone" or board.grid[player.y + 2][player.x] ~= "stone") then
                player.y = player.y + 1
            end
            if love.keyboard.isDown( "left" )
            and player.x > 2
            and board.grid[player.y][player.x - 1] ~= "water"
            and board.grid[player.y][player.x - 1] ~= "lava"
            and board.grid[player.y][player.x - 1] ~= "tree"
            and (board.grid[player.y][player.x - 1] ~= "stone" or board.grid[player.y][player.x - 2] ~= "stone") then
                player.x = player.x - 1
            end
            if love.keyboard.isDown( "right" )
            and player.x < gridXCount - 1
            and board.grid[player.y][player.x + 1] ~= "water"
            and board.grid[player.y][player.x + 1] ~= "lava"
            and board.grid[player.y][player.x + 1] ~= "tree"
            and (board.grid[player.y][player.x + 1] ~= "stone" or board.grid[player.y][player.x + 2] ~= "stone") then
                player.x = player.x + 1
            end

            -- Push Stone
            for k,stone in pairs(stone_table) do
                if stone.x == player.x
                and stone.y == player.y then
                    if love.keyboard.isDown( "up" )
                    and stone.y > 3 then
                        stone.y = stone.y - 1
                    end
                    if love.keyboard.isDown( "down" )
                    and stone.y < gridYCount - 2 then
                        stone.y = stone.y + 1
                    end
                    if love.keyboard.isDown( "left" )
                    and stone.x > 3 then
                        stone.x = stone.x - 1
                    end
                    if love.keyboard.isDown( "right" )
                    and stone.x < gridXCount - 2 then
                        stone.x = stone.x + 1
                    end
                end
            end

            -- Cut Tree
            for k,tree in pairs(tree_table) do
                if love.keyboard.isDown( "up" )
                and tree.x == player.x
                and tree.y + 1 == player.y then
                    tree.hp = tree.hp - 1
                end
                if love.keyboard.isDown( "down" )
                and tree.x == player.x
                and tree.y - 1 == player.y then
                    tree.hp = tree.hp - 1
                end
                if love.keyboard.isDown( "left" )
                and tree.x + 1 == player.x
                and tree.y == player.y then
                    tree.hp = tree.hp - 1
                end
                if love.keyboard.isDown( "right" )
                and tree.x - 1 == player.x
                and tree.y == player.y then
                    tree.hp = tree.hp - 1
                end
                if tree.hp < 1 then
                    table.insert(stone_table, Stone:Create(tree.x,tree.y,1))
                    board.grid[tree.y][tree.x] = "dirt"
                    table.remove(tree_table,k)
                end
            end
        end
    elseif timer >= 2 then
        reset()
    end
end

--------------------------------------------------------------------------------

-- Draw Everything
function love.draw()
    board:Animate()
    for k,v in pairs(stone_table) do
        v:Animate()
    end
    for k,v in pairs(lava_table) do
        v:Animate()
    end
    for k,v in pairs(tree_table) do
        v:Animate()
    end
    player:Animate()
end

--------------------------------------------------------------------------------

-- Menu Controls
function love.keypressed(key)
    if key == 'q' then
        timerLimit = timerLimit + 0.005
    elseif key == 'w' then
        timerLimit = timerLimit - 0.005
    elseif key == 'e' then
        timerLimit = 0.1
    end
end
