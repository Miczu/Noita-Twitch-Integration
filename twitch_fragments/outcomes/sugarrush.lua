--Sugar Rush
--Enemies feel... different
--detrimental
--20
--
function twitch_sugarrush()
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

    if (player) then
        local x, y = get_player_pos()
        local thingy = EntityLoad("mods/twitch-integration/files/effects/sugar_rush.xml", x, y)
        EntityAddChild(player, thingy)
    end
end
