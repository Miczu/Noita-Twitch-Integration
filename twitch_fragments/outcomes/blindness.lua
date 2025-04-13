--Blindness
--Good luck
--bad_effects
--150
--todo
function twitch_blindness()
    async(effect_blindness)
end

function effect_blindness()
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

    local game_effect = GetGameEffectLoadTo(player, "BLINDNESS", false);
    if game_effect ~= nil then ComponentSetValue(game_effect, "frames", 600); end
end
