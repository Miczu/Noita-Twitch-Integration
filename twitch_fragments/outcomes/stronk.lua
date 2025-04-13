--Stronk
--Very stronk for a bit
--good_effects
--360
--todo
function twitch_stronk()
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

    local effect = CellFactory_GetType("twitch_stronk")
    EntityIngestMaterial( player, effect, 60 )
    empty_player_stomach()
end
