--Sanic's curse
--They come for your rings!!
--curses
--80
--todo
function twitch_sanic_curse()
    local player = get_player()
    local effect = CellFactory_GetType("twitch_sanic_curse")
    EntityIngestMaterial( player, effect, 120 )
    empty_player_stomach()
end
