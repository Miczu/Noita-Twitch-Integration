--The Purge
--BATTLE ROYALE
--perks
--300
--Everyone against eachother
function twitch_the_purge()
    async(effect_the_purge)
end

function effect_the_purge()
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

    local effect = CellFactory_GetType("twitch_purge")
    EntityIngestMaterial( player, effect, 120)
    empty_player_stomach()
end