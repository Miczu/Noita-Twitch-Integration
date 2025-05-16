--Big Confuse
--?????????
--bad_effects
--170
--confuses player?
function twitch_big_confuse()
    local player = get_player()
    local effect = CellFactory_GetType("twitch_big_confuse")
    EntityIngestMaterial( player, effect, 10 )
    empty_player_stomach()
end
