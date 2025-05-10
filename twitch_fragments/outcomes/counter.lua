--Counter!
--No u
--good_effects
--300
--counters melee hits
function twitch_counter()
    async(effect_counter)
end

function effect_counter()
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

    local effect = CellFactory_GetType("twitch_counter")
    EntityIngestMaterial( player, effect, 90 )
    empty_player_stomach()
end