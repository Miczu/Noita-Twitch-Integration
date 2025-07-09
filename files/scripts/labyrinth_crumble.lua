local entity = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity)
local width = 15
local height = 15
local cell_size = 20

local anchor_x = x - math.floor((width * cell_size) * 0.5) + (cell_size * 1.5)
local anchor_y = y - math.floor((height * cell_size) * 0.5) + (cell_size * 2.5)

for i = 0, 4 do
    for j = 0, 4 do
        local crumble_x = anchor_x + (i * cell_size * 3)
        local crumble_y = anchor_y + (j * cell_size * 3)
        EntityLoad("mods/twitch-integration/files/entities/labyrinth/labyrinth_crumbler.xml", crumble_x, crumble_y)
        print("crumble: "..tostring(crumble_x)..", "..tostring(crumble_y))
    end
end

GamePlaySound("data/audio/Desktop/misc.bank", "player_projectiles/crumbling_earth/create", x, y)

EntityKill(entity)