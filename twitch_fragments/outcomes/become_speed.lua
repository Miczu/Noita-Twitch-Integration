--Become speed
--I AM SPEED
--bad_effects
--250
--
function twitch_become_speed()
    local player = get_player()
    local effect = CellFactory_GetType("twitch_speed")
    EntityIngestMaterial( player, effect, 30 )
    empty_player_stomach()
end
