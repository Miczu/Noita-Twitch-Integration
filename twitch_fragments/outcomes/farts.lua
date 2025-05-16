--Farts
--Geez what did you eat!?
--perks
--150
--todo
function twitch_farts()
    local player = get_player()
    local effect = CellFactory_GetType("twitch_farts")
    EntityIngestMaterial( player, effect, 240 )
    empty_player_stomach()
end
