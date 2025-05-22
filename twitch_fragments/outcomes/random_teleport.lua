--Random Teleport
--Where'd ya go?!?!?
--bad_effects
--200
--todo
function twitch_random_teleport()
    local player = get_player()
    local game_effect = GetGameEffectLoadTo(player, "UNSTABLE_TELEPORTATION", true);
    if game_effect ~= nil then ComponentSetValue(game_effect, "frames", 60); end
end
