--Shrooms
--What a trip
--bad_effects
--230
--todo
function twitch_shrooms()
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

    local fungi = CellFactory_GetType("fungi")
    EntityIngestMaterial( player, fungi, 150 )
    empty_player_stomach()
end
