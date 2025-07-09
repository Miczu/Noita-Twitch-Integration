function recursive_labyrinth_build(width, height, cx, cy, cells)
    cells[cx][cy].visited = true
    local dx = { ["E"] = 1, ["W"] = -1, ["N"] = 0, ["S"] = 0 }
    local dy = { ["E"] = 0, ["W"] = 0, ["N"] = -1, ["S"] = 1 }
    local opposite = { ["E"] = "W", ["W"] = "E", ["N"] = "S", ["S"] = "N" }
    local directions = { "N", "S", "E", "W" }
    for i = #directions, 2, -1 do
        local j = Random(1, i)
        directions[i], directions[j] = directions[j], directions[i]
    end
    for i = 1, #directions do
        local nx, ny = cx + dx[directions[i]], cy + dy[directions[i]]
        if nx > 0 and nx <= width
        and ny > 0 and ny <= height
        and cells[nx][ny].visited == false then
            cells[cx][cy].walls[directions[i]] = false
            cells[nx][ny].walls[opposite[directions[i]]] = false
            cells = recursive_labyrinth_build(width, height, nx, ny, cells)
        end
    end
    return cells
end

function generate_labyrinth(width, height, x, y)
    SetRandomSeed(x + 69, y + 420)
    local cell_size = 20
    local anchor_x = x - math.floor((width * cell_size) * 0.5)
    local anchor_y = y - math.floor((height * cell_size) * 0.5)
    local exit_sides = "NS"
    local exit_wall = Random(1, width)
    local exit_arrows = {}
    if Random(1, 2) == 2 then
        exit_sides = "EW"
        exit_wall = Random(1, height)
    end
    local cells = {}
    for i = 1, width do
        cells[i] = {}
        for j = 1, height do
            cells[i][j] = { visited = false, walls = { ["N"] = true, ["S"] = true, ["E"] = true, ["W"] = true } }
            if exit_sides == "NS" then
                if j == 1 and i == exit_wall then
                    cells[i][j].walls["N"] = false
                    table.insert(exit_arrows, { math.pi * 1.5, i, j, "N" })
                end
                if j == height and i == (width - exit_wall + 1) then
                    cells[i][j].walls["S"] = false
                    table.insert(exit_arrows, { math.pi * 0.5, i, j, "S" })
                end
            elseif exit_sides == "EW" then
                if i == 1 and j == exit_wall then
                    cells[i][j].walls["W"] = false
                    table.insert(exit_arrows, { math.pi, i, j, "W" })
                end
                if i == width and j == (height - exit_wall + 1) then
                    cells[i][j].walls["E"] = false
                    table.insert(exit_arrows, { 0, i, j, "E" })
                end
            end
        end
    end
    cells = recursive_labyrinth_build(width, height, 1, 1, cells)
    LoadPixelScene(
        "mods/twitch-integration/files/pixel_scenes/labyrinth/labyrinth_air.png",
        "mods/twitch-integration/files/pixel_scenes/labyrinth/labyrinth_transparent.png",
        anchor_x - 16, anchor_y - 16,
        "mods/twitch-integration/files/pixel_scenes/labyrinth/labyrinth_bg.png",
        true, false, {}, 1, true
    )
    for i = 1, width do
        for j = 1, height do
            local cell = cells[i][j]
            local pixel_x = anchor_x + ((i - 1) * cell_size) - 1
            local pixel_y = anchor_y + ((j - 1) * cell_size) - 1
            if cell.walls["N"] then
                if j ~= 1 and Random(1, 40) == 1 then
                    LoadPixelScene("mods/twitch-integration/files/pixel_scenes/labyrinth/labyrinth_wall_horizontal_ice.png", "", pixel_x, pixel_y, "", true, false, {}, 1, true)
                else
                    LoadPixelScene("mods/twitch-integration/files/pixel_scenes/labyrinth/labyrinth_wall_horizontal.png", "", pixel_x, pixel_y, "", true, false, {}, 1, true)
                end
            end
            if cell.walls["W"] then
                if i ~= 1 and Random(1, 40) == 1 then
                    LoadPixelScene("mods/twitch-integration/files/pixel_scenes/labyrinth/labyrinth_wall_vertical_ice.png", "", pixel_x, pixel_y, "", true, false, {}, 1, true)
                else
                    LoadPixelScene("mods/twitch-integration/files/pixel_scenes/labyrinth/labyrinth_wall_vertical.png", "", pixel_x, pixel_y, "", true, false, {}, 1, true)
                end
            end
            if j == height and cell.walls["S"] then
                LoadPixelScene("mods/twitch-integration/files/pixel_scenes/labyrinth/labyrinth_wall_horizontal.png", "", pixel_x, pixel_y + cell_size + 1, "", true, false, {}, 1, true)
            end
            if i == width and cell.walls["E"] then
                LoadPixelScene("mods/twitch-integration/files/pixel_scenes/labyrinth/labyrinth_wall_vertical.png", "", pixel_x + cell_size + 1, pixel_y, "", true, false, {}, 1, true)
            end
        end
    end
    local entity = GetUpdatedEntityID()
    local arrows = EntityGetAllChildren(entity)
    for i = 1, #exit_arrows do
        local exit_arrow = exit_arrows[i]
        local arrow_x = anchor_x + (exit_arrow[2] * cell_size)
        local arrow_y =  anchor_y + (exit_arrow[3] * cell_size)
        if exit_arrow[4] == "N" then 
            arrow_x = arrow_x - (cell_size * 0.5)
            arrow_y = arrow_y - cell_size
        elseif exit_arrow[4] == "S" then 
            arrow_x = arrow_x - (cell_size * 0.5)
        elseif exit_arrow[4] == "E" then
            arrow_y = arrow_y - (cell_size * 0.5)
        elseif exit_arrow[4] == "W" then
            arrow_x = arrow_x - cell_size
            arrow_y = arrow_y - (cell_size * 0.5)
        end 
        EntitySetTransform(arrows[i], arrow_x, arrow_y, exit_arrow[1])
    end
end

local entity = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity)
generate_labyrinth(15, 15, x, y)

GamePlaySound("data/audio/Desktop/misc.bank", "misc/beam_from_sky_kick", x, y)

local inherit_transform = EntityGetFirstComponent(entity, "InheritTransformComponent")
if inherit_transform then EntityRemoveComponent(entity, inherit_transform) end