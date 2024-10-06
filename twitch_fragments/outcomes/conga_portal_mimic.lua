--Portal Mimic
--Slurp
--traps
--150
--
function twitch_conga_portal_mimic()
    local players = EntityGetWithTag("player_unit")
    for k=1,#players
    do v = players[k]
        local x,y = EntityGetTransform(v)
        local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_portal_mimic.xml",x,y)
        EntityAddChild(v,c)
    end
end

