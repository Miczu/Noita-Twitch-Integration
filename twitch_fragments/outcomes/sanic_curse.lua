--Sanic's curse
--They come for your rings!!
--curses
--80
--todo
function twitch_sanic_curse()
    async(effect_sanic_curse)
end

function effect_sanic_curse()
    
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

    local effect = CellFactory_GetType("twitch_sanic_curse")
    EntityIngestMaterial( player, effect, 120 )
    empty_player_stomach()
end
