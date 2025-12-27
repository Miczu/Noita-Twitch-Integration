--Moneyshot
--Everything comes at a price.
--curses
--90
--todo
function twitch_moneyshot()
    async(effect_moneyshot)
end

function effect_moneyshot()
    
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

    local effect = CellFactory_GetType("twitch_moneyshot")
    EntityIngestMaterial( player, effect, 60 )
    empty_player_stomach()
end
