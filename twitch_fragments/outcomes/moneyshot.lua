--Moneyshot
--Everything comes at a price.
--curses
--90
--todo
function twitch_moneyshot()
    local player = get_player()
    local effect = CellFactory_GetType("twitch_moneyshot")
    EntityIngestMaterial( player, effect, 60 )
    empty_player_stomach()
end
