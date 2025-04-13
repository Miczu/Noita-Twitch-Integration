--Dryspell
--Cool?
--perks
--220
--todo
function twitch_dryspell()
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

    local effect = CellFactory_GetType("twitch_dryspell")
    EntityIngestMaterial( player, effect, 150 )
    empty_player_stomach()
end