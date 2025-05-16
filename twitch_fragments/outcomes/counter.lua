--Counter!
--No u
--good_effects
--300
--counters melee hits
function twitch_counter()
    local player = get_player()
    local effect = CellFactory_GetType("twitch_counter")
    EntityIngestMaterial( player, effect, 90 )
    empty_player_stomach()
end