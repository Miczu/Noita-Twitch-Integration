--Labyrinth
--You have 30 seconds to escape
--enviromental
--80
--Spawns a 15x15 cell labyinth around the player with 2 exits, which crumbles to pieces after 30 seconds
function twitch_labyrinth()
    local player = get_player_event()
    if player then
        local x, y = EntityGetTransform(player)
        local labyrinth_spawner = EntityLoad("mods/twitch-integration/files/entities/labyrinth/labyrinth_spawner.xml", x, y)
        EntityAddChild(player, labyrinth_spawner)
    end
end