--Portal Mimic
--Slurp
--traps
--150
--
function twitch_conga_portal_mimic()
    local players = get_player_as_table()
    for k=1,#players
    do v = players[k]
        local x,y = EntityGetTransform(v)
        local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_portal_mimic.xml",x,y)
        EntityAddChild(v,c)
    end
end

