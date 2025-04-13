--Big Confuse
--?????????
--bad_effects
--170
--confuses player?
function twitch_big_confuse()
    async(big_confuse_effect)
end

function big_confuse_effect()
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;
    
    local effect = CellFactory_GetType("twitch_big_confuse")
    EntityIngestMaterial( player, effect, 10 )
    empty_player_stomach()
end
