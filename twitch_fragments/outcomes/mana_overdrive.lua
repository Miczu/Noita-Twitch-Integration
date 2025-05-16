--Mana Overdrive
--Lots of mana for now
--good_effects
--340
--todo
function twitch_mana_overdrive()
    async(effect_mana_overdrive)
end

function effect_mana_overdrive()
    
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

    local effect = CellFactory_GetType("twitch_mana_overdrive")
    EntityIngestMaterial( player, effect, 60 )
    empty_player_stomach()
end
