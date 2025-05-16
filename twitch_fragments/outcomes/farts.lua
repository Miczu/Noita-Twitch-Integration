--Farts
--Geez what did you eat!?
--perks
--150
--todo
function twitch_farts()
    async(effect_farts)
end

function effect_farts()
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

    local effect = CellFactory_GetType("twitch_farts")
    EntityIngestMaterial( player, effect, 240 )
    empty_player_stomach()
end
