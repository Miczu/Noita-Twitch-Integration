--Dryspell
--Cool?
--perks
--220
--todo
function twitch_dryspell()
    local player = get_player()
    local effect = CellFactory_GetType("twitch_dryspell")
    EntityIngestMaterial( player, effect, 150 )
    empty_player_stomach()
end