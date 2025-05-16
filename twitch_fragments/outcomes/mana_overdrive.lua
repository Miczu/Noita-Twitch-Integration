--Mana Overdrive
--Lots of mana for now
--good_effects
--340
--todo
function twitch_mana_overdrive()
    local player = get_player()
    local effect = CellFactory_GetType("twitch_mana_overdrive")
    EntityIngestMaterial( player, effect, 60 )
    empty_player_stomach()
end
