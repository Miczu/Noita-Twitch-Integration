--The Purge
--BATTLE ROYALE
--perks
--300
--Everyone against eachother
function twitch_the_purge()
    local player = get_player()
    local effect = CellFactory_GetType("twitch_purge")
    EntityIngestMaterial( player, effect, 120)
    empty_player_stomach()
end