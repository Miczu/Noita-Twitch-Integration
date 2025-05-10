--Portal Mimic
--Slurp
--traps
--150
--
function twitch_conga_portal_mimic()
    async(effect_conga_portal_mimic)
end

function effect_conga_portal_mimic()
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

    local x,y = EntityGetTransform(player)
    local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_portal_mimic.xml",x,y)
    EntityAddChild(player,c)
end

