--Shrooms
--What a trip
--bad_effects
--230
--todo
function twitch_shrooms()
    local player = get_player()
    local fungi = CellFactory_GetType("fungi")
    EntityIngestMaterial( player, fungi, 150 )
    empty_player_stomach()
end
