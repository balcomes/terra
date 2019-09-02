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
    woodchuck_table = {}

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

    -- Player Drawing Function
    function drawPlayer(x, y)
        -- Hat
        love.graphics.setColor(1, 0, 1)
        love.graphics.rectangle(
            'fill',
            (x - 1) * cellSize,
            (y - 1) * cellSize,
            cellSize - 1,
            cellSize/3 - 1
        )
        -- Face
        love.graphics.setColor(.8, .8, .8)
        love.graphics.rectangle(
            'fill',
            (x - 1) * cellSize,
            (y - 1) * cellSize + cellSize/3,
            cellSize - 1,
            cellSize/3 - 1
        )
        -- Eyes
        love.graphics.setColor(.1, .1, .1)
        love.graphics.rectangle(
            'fill',
            (x - 1) * cellSize + cellSize/5,
            (y - 1) * cellSize + cellSize/3,
            cellSize - 1 - 4*cellSize/5,
            cellSize/4 - 1
        )
        -- Eyes
        love.graphics.setColor(.1, .1, .1)
        love.graphics.rectangle(
            'fill',
            (x - 1) * cellSize + 3*cellSize/5,
            (y - 1) * cellSize + cellSize/3,
            cellSize - 1 - 4*cellSize/5,
            cellSize/4 - 1
        )
        -- Pants
        love.graphics.setColor(.1, .2, .8)
        love.graphics.rectangle(
            'fill',
            (x - 1) * cellSize,
            (y - 1) * cellSize + 2*cellSize/3,
            cellSize - 1,
            cellSize/3 - 1
        )
    end

    -- Woodchuck Drawing Function
    function drawWoodchuck(x, y)
        -- Hat
        love.graphics.setColor(.5, .5, .1)
        love.graphics.rectangle(
            'fill',
            (x - 1) * cellSize,
            (y - 1) * cellSize,
            cellSize - 1,
            cellSize/3 - 1
        )
        -- Face
        love.graphics.setColor(.7, .7, .1)
        love.graphics.rectangle(
            'fill',
            (x - 1) * cellSize,
            (y - 1) * cellSize + cellSize/3,
            cellSize - 1,
            cellSize/3 - 1
        )
        -- Eyes
        love.graphics.setColor(.1, .1, .1)
        love.graphics.rectangle(
            'fill',
            (x - 1) * cellSize + cellSize/5,
            (y - 1) * cellSize + cellSize/3,
            cellSize - 1 - 4*cellSize/5,
            cellSize/4 - 1
        )
        -- Eyes
        love.graphics.setColor(.1, .1, .1)
        love.graphics.rectangle(
            'fill',
            (x - 1) * cellSize + 3*cellSize/5,
            (y - 1) * cellSize + cellSize/3,
            cellSize - 1 - 4*cellSize/5,
            cellSize/4 - 1
        )
        -- Pants
        love.graphics.setColor(.5, .5, .1)
        love.graphics.rectangle(
            'fill',
            (x - 1) * cellSize,
            (y - 1) * cellSize + 2*cellSize/3,
            cellSize - 1,
            cellSize/3 - 1
        )
    end

    -- Respawn Player
    function reset()
        player = Player:Create()
    end

--------------------------------------------------------------------------------
-- Player
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
        drawPlayer(self.x, self.y)
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
    -- Woodchuck
    --------------------------------------------------------------------------------

    -- Woodchuck Class
    Woodchuck = {}
    Woodchuck.__index = Woodchuck
    function Woodchuck:Create(xo, yo)
        local this =
        {
            x = xo,
            y = yo,
            c1 = 0,
            c2 = 0,
            c3 = 0,
            name = RandomVariable(9),
            alive = true,
            fertile = true,
        }
        setmetatable(this, Woodchuck)
        return this
    end

    -- Woodchuck Animate
    function Woodchuck:Animate()
        love.graphics.setColor(self.c1, self.c2, self.c3)
        drawWoodchuck(self.x, self.y)
    end

    -- Woodchuck Move
    function Woodchuck:Move()
        if math.random() < 0.5 then
            direction = math.floor(math.random()*5)
            if direction == 1
            and self.y > 2
            and board.grid[self.y - 1][self.x] ~= "water"
            and board.grid[self.y - 1][self.x] ~= "lava"
            and (board.grid[self.y - 1][self.x] ~= "stone" or board.grid[self.y - 2][self.x] ~= "stone") then
                self.y = self.y - 1
            end
            if direction == 2
            and self.y > 2
            and board.grid[self.y + 1][self.x] ~= "water"
            and board.grid[self.y + 1][self.x] ~= "lava"
            and (board.grid[self.y + 1][self.x] ~= "stone" or board.grid[self.y - 2][self.x] ~= "stone") then
                self.y = self.y + 1
            end
            if direction == 3
            and self.y > 2
            and board.grid[self.y][self.x - 1] ~= "water"
            and board.grid[self.y][self.x - 1] ~= "lava"
            and (board.grid[self.y][self.x - 1] ~= "stone" or board.grid[self.y - 2][self.x] ~= "stone") then
                self.x = self.x - 1
            end
            if direction == 4
            and self.y > 2
            and board.grid[self.y - 1][self.x + 1] ~= "water"
            and board.grid[self.y - 1][self.x + 1] ~= "lava"
            and (board.grid[self.y - 1][self.x + 1] ~= "stone" or board.grid[self.y - 2][self.x] ~= "stone") then
                self.x = self.x + 1
            end
        end
    end

    -- Woodchuck Drown
    function Woodchuck:Drown()
        if board.grid[self.y-1][self.x] == "water"
            and board.grid[self.y][self.x-1] == "water"
            and board.grid[self.y][self.x+1] == "water"
            and board.grid[self.y+1][self.x] == "water" then
                self.alive = false
        end
    end

--------------------------------------------------------------------------------
-- Water
--------------------------------------------------------------------------------

    -- Water Class
    Water = {}
    Water.__index = Water
    function Water:Create(xo,yo)
        local this =
        {
            x = xo,
            y = yo,
            c1 = math.random()/4,
            c2 = math.random()/4,
            c3 = math.random()/2 + 0.5,
            blink = true,
        }
        setmetatable(this, Water)
        return this
    end

    -- Water Blink
    function Water:Blink()
        if math.random() < 0.01 then
            self.c1 = math.random()/4
            self.c2 = math.random()/4
            self.c3 = math.random()/2 + 0.5
        end
    end

    -- Water Animate
    function Water:Animate()
        love.graphics.setColor(self.c1, self.c2, self.c3)
        if self.blink == true then
            self:Blink()
        end
        drawCell(self.x, self.y)
    end

--------------------------------------------------------------------------------
-- Dirt
--------------------------------------------------------------------------------

    -- Dirt Class
    Dirt = {}
    Dirt.__index = Dirt
    function Dirt:Create(xo,yo)
        local this =
        {
            x = xo,
            y = yo,
            c1 = 150/255,
            c2 = 150/255,
            c3 = 100/255,
        }
        setmetatable(this, Dirt)
        return this
    end

    -- Dirt Animate
    function Dirt:Animate()
        love.graphics.setColor(self.c1, self.c2, self.c3)
        drawCell(self.x, self.y)
    end

    -- Dirt to Sand
    function Dirt:Dirt_to_Sand()
        local result = false
        dirt_water = spread(board.grid,self.x,self.y,"water")
        if math.random() < dirt_water/80 then
            board.grid[self.y][self.x] = "sand"
            table.insert(sand_table, Sand:Create(self.x,self.y))
            result = true
        end
        return result
    end

    -- Dirt to Grass
    function Dirt:Dirt_to_Grass()
        local result = false
        grass_tree = spread(board.grid, self.x, self.y, "grass")
        if math.random() < grass_tree/2000 + 0.001 then
            board.grid[self.y][self.x] = "grass"
            table.insert(grass_table, Grass:Create(self.x, self.y))
            result = true
        end
        return result
    end

--------------------------------------------------------------------------------
-- Sand
--------------------------------------------------------------------------------

    -- Sand Class
    Sand = {}
    Sand.__index = Sand
    function Sand:Create(xo,yo)
        local this =
        {
            x = xo,
            y = yo,
            c1 = 200/255,
            c2 = 200/255,
            c3 = 200/255,
        }
        setmetatable(this, Sand)
        return this
    end

    -- Sand Animate
    function Sand:Animate()
        love.graphics.setColor(self.c1, self.c2, self.c3)
        drawCell(self.x, self.y)
        board.grid[self.y][self.x] = "sand"
    end

    -- Sand to Water
    function Sand:Sand_to_Water()
        local result = false
        sand_water = spread(board.grid, self.x, self.y, "water")
        if math.random() < sand_water/2000 then
            board.grid[self.y][self.x] = "water"
            table.insert(water_table, Water:Create(self.x, self.y))
            result = true
        end
        return result
    end

    -- Sand to Dirt
    function Sand:Sand_to_Dirt()
        local result = false
        sand_grass = spread(board.grid, self.x, self.y, "grass")
        if math.random() < sand_grass/2000 then
            board.grid[self.y][self.x] = "dirt"
            table.insert(dirt_table, Dirt:Create(self.x, self.y))
            result = true
        end
        return result
    end

--------------------------------------------------------------------------------
-- Grass
--------------------------------------------------------------------------------

    -- Grass Class
    Grass = {}
    Grass.__index = Grass
    function Grass:Create(xo,yo)
        local this =
        {
            x = xo,
            y = yo,
            c1 = 50/255,
            c2 = 200/255,
            c3 = 50/255,
        }
        setmetatable(this, Grass)
        return this
    end

    -- Grass Animate
    function Grass:Animate()
        love.graphics.setColor(self.c1, self.c2, self.c3)
        drawCell(self.x, self.y)
    end

    -- Grass to Tree
    function Grass:Grass_to_Tree()
        local result = false
        grass_tree = spread(board.grid, self.x, self.y, "tree")
        if math.random() < grass_tree/2000 + 0.0001 then
            board.grid[self.y][self.x] = "tree"
            table.insert(tree_table, Tree:Create(self.x, self.y))
            result = true
        end
        return result
    end

    -- Grass to Dirt (Player Trample)
    function Grass:Grass_to_Dirt()
        local result = false
        if self.x == player.x and self.y == player.y then
            board.grid[self.y][self.x] = "dirt"
            table.insert(dirt_table, Dirt:Create(self.x, self.y))
            result = true
        end
        return result
    end

    --------------------------------------------------------------------------------
    -- Tree
    --------------------------------------------------------------------------------

    -- Tree Class
    Tree = {}
    Tree.__index = Tree
    function Tree:Create(xo,yo)
        local this =
        {
            x = xo,
            y = yo,
            c1 = 10/255,
            c2 = 100/255,
            c3 = 10/255,
            hp = 10,
        }
        setmetatable(this, Tree)
        return this
    end

    -- Tree Animate
    function Tree:Animate()
        love.graphics.setColor(self.c1, self.c2, self.c3)
        drawCell(self.x, self.y)
    end

    -- Tree to Stone
    function Tree:Tree_to_Stone()
        board.grid[self.y][self.x] = "stone"
        table.insert(dirt_table, Dirt:Create(self.x, self.y))
        table.insert(stone_table, Stone:Create(self.x, self.y))
    end

--------------------------------------------------------------------------------
-- Lava
--------------------------------------------------------------------------------
    -- Lava Class
    Lava = {}
    Lava.__index = Lava
    function Lava:Create(xo,yo)
        local this =
        {
            x = xo,
            y = yo,
            c1 = math.random(200/255,255/255),
            c2 = 100/255,
            c3 = 100/255,
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

    -- Lava to Dirt
    function Lava:Lava_to_Dirt()
        local result = false
        if math.random() < 0.01 then
            board.grid[self.y][self.x] = "dirt"
            table.insert(dirt_table, Dirt:Create(self.x, self.y))
            result = true
        end
        return result
    end

--------------------------------------------------------------------------------
-- Stone
--------------------------------------------------------------------------------

    -- Stone Class
    Stone = {}
    Stone.__index = Stone
    function Stone:Create(xo,yo)
        local this =
        {
            x = xo,
            y = yo,
            c1 = 40/255,
            c2 = 50/255,
            c3 = 60/255,
        }
        setmetatable(this, Stone)
        return this
    end

    -- Stone Animate
    function Stone:Animate()
        love.graphics.setColor(self.c1, self.c2, self.c3)
        drawCell(self.x, self.y)
    end

    -- Stone to Dirt
    function Stone:Stone_to_Dirt()
        local result = false
        stone_water = spread(board.grid,self.x,self.y,"water")
        if math.random() < stone_water/80 then
            board.grid[self.y][self.x] = "dirt"
            table.insert(dirt_table, Dirt:Create(self.x,self.y))
            result = true
        end
        return result
    end

--------------------------------------------------------------------------------
-- Board
--------------------------------------------------------------------------------

    -- Board Class
    Board = {}
    Board.__index = Board
    function Board:Create()
        local this =
        {
            grid = {},
        }
        for y = 1, gridYCount do
            this.grid[y] = {}
            for x = 1, gridXCount do
                this.grid[y][x] = ""
            end
        end
        setmetatable(this, Board)
        return this
    end

    -- Board Clear
    function Board:Clear()
        for y = 1, gridYCount do
            self.grid[y] = {}
            for x = 1, gridXCount do
                self.grid[y][x] = ""
            end
        end
    end

    -- Board Water Fill
    function Board:Ocean()
        for y = 1, gridYCount do
            for x = 1, gridXCount do
                table.insert(water_table, Water:Create(x,y))
            end
        end
    end

    -- Board Island Fill
    function Board:Island()
        for y = 10, gridYCount - 10 do
            for x = 10, gridXCount -10 do
                table.insert(dirt_table, Dirt:Create(x,y))
            end
        end
    end

    -- Setup Board
    board = Board:Create()
    Board:Ocean()
    Board:Island()
    table.insert(woodchuck_table,Woodchuck:Create(math.floor(gridXCount/2) - 1, math.floor(gridYCount/2 - 1)))
    -- Spawn Player
    reset()
end

--------------------------------------------------------------------------------

function love.update(dt)
    timer = timer + dt
    if player.alive then
        -- Handle Frames
        if timer >= timerLimit then
            -- Handle Game Speed
            timer = timer - timerLimit
            player:Drown()
            for k,v in pairs(woodchuck_table) do
                v:Drown()
                if v.alive == false then
                    table.remove(woodchuck_table, k)
                end
            end


            -- Update Board
            for k,v in pairs(water_table) do
                board.grid[v.y][v.x] = "water"
            end
            for k,v in pairs(dirt_table) do
                board.grid[v.y][v.x] = "dirt"
            end
            for k,v in pairs(sand_table) do
                board.grid[v.y][v.x] = "sand"
            end
            for k,v in pairs(grass_table) do
                board.grid[v.y][v.x] = "grass"
            end
            for k,v in pairs(stone_table) do
                board.grid[v.y][v.x] = "stone"
            end
            for k,v in pairs(lava_table) do
                board.grid[v.y][v.x] = "lava"
            end
            for k,v in pairs(tree_table) do
                board.grid[v.y][v.x] = "tree"
            end

            -- Erode
            for k,v in pairs(water_table) do

            end
            for k,v in pairs(dirt_table) do
                if v:Dirt_to_Sand() then
                    table.remove(dirt_table, k)
                end
                if v:Dirt_to_Grass() then
                    table.remove(dirt_table, k)
                end
            end
            for k,v in pairs(sand_table) do
                if v:Sand_to_Water() then
                    table.remove(sand_table, k)
                end
                if v:Sand_to_Dirt() then
                    table.remove(sand_table, k)
                end
            end
            for k,v in pairs(grass_table) do
                if v:Grass_to_Tree() then
                    table.remove(grass_table, k)
                end
                if v:Grass_to_Dirt() then
                    table.remove(grass_table, k)
                end
            end
            for k,v in pairs(stone_table) do
                if v:Stone_to_Dirt() then
                    table.remove(stone_table, k)
                end
            end
            for k,v in pairs(lava_table) do
                if v:Lava_to_Dirt() then
                    table.remove(lava_table, k)
                end
            end
            for k,v in pairs(tree_table) do

            end

            -- Spread Lava
            function Spread_Lava()
                for y = 2, gridYCount - 1 do
                    for x = 2, gridXCount -1 do
                        if board.grid[y][x] ~= "stone" or board.grid[y][x] ~= "lava" then
                            any_lava = spread(board.grid,x,y,"lava")
                            if board.grid[y][x] == "water" then
                                water_lava = spread(board.grid,x,y,"lava")
                                if math.random() < any_lava/500 then
                                    board.grid[y][x] = "lava"
                                    table.insert(lava_table, Lava:Create(x,y))
                                end
                            elseif math.random() < any_lava/500 then
                                if math.random() < 0.1 then
                                    board.grid[y][x] = "lava"
                                    table.insert(stone_table, Stone:Create(x,y))
                                    board.grid[y][x] = "stone"
                                else
                                    board.grid[y][x] = "lava"
                                    table.insert(lava_table, Lava:Create(x,y))
                                end
                            end
                        end
                    end
                end
            end
            Spread_Lava()

            -- Add a Volcano
            if math.random() < 1/10 then
                x = math.random(5, gridXCount - 5)
                y = math.random(5, gridYCount - 5)
                board.grid[y][x] = "lava"
                table.insert(lava_table, Lava:Create(x,y))
            end

            -- Move Woodchucks
            for k,v in pairs(woodchuck_table) do
                v:Move()
            end

            -- Push Stone
            for k,stone in pairs(stone_table) do
                if stone.x == player.x
                and stone.y == player.y - 1 then
                    if love.keyboard.isDown( "up" )
                    and stone.y > 3 then
                        stone.y = player.y - 2
                    end
                end
                if stone.x == player.x
                and stone.y == player.y + 1 then
                    if love.keyboard.isDown( "down" )
                    and stone.y < gridYCount - 2 then
                        stone.y = player.y + 2
                    end
                end
                if stone.x == player.x - 1
                and stone.y == player.y then
                    if love.keyboard.isDown( "left" )
                    and stone.x > 3 then
                        stone.x = player.x - 2
                    end
                end
                if stone.x == player.x + 1
                and stone.y == player.y then
                    if love.keyboard.isDown( "right" )
                    and stone.x < gridXCount - 2 then
                        stone.x = player.x + 2
                    end
                end
            end

            -- Eat Tree
            for kt,tree in pairs(tree_table) do
                for kw,wc in pairs(woodchuck_table) do
                    if wc.x == tree.x and wc.y == tree.y then
                        tree.hp = tree.hp - 1
                        if tree.hp < 1 then
                            tree:Tree_to_Stone()
                            table.remove(tree_table, k)
                            if wc.fertile == true then
                                wc.fertile = false
                                table.insert(woodchuck_table,Woodchuck:Create(wc.x,wc.y))
                                if math.random() < 0.1 then
                                    table.insert(woodchuck_table,Woodchuck:Create(wc.x,wc.y))
                                end
                            break end
                        end
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
                    tree:Tree_to_Stone()
                    table.remove(tree_table, k)
                end
            end

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
        end
    elseif timer >= 2 then
        reset()
    end
end

--------------------------------------------------------------------------------

-- Draw Everything
function love.draw()
    for k,v in pairs(water_table) do
        v:Animate()
    end
    for k,v in pairs(dirt_table) do
        v:Animate()
    end
    for k,v in pairs(sand_table) do
        v:Animate()
    end
    for k,v in pairs(grass_table) do
        v:Animate()
    end
    for k,v in pairs(stone_table) do
        v:Animate()
    end
    for k,v in pairs(lava_table) do
        v:Animate()
    end
    for k,v in pairs(tree_table) do
        v:Animate()
    end
    for k,v in pairs(woodchuck_table) do
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
