--CHONKY
--That's one CHONKY Noita
--perks
--220
--Makes the player stomp cause damage to the terrain
function twitch_chonky()
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

    local effect = CellFactory_GetType("twitch_chonky")
    EntityIngestMaterial( player, effect, 120 )
    empty_player_stomach()
end