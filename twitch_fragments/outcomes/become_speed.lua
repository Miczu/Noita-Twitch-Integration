--Become speed
--I AM SPEED
--bad_effects
--250
--
function twitch_become_speed()
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

    local effect = CellFactory_GetType("twitch_speed")
    EntityIngestMaterial( player, effect, 30 )
    empty_player_stomach()
end
