--The Rarest Mimic
--Chomp
--traps
--200
--
function twitch_conga_refresh_mimic()
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

    local x,y = EntityGetTransform(player)
    local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_hm_mimic.xml",x,y)
    EntityAddChild(player,c)
end

