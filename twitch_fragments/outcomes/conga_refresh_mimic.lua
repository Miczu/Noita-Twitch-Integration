--The Rarest Mimic
--Chomp
--traps
--200
--
function twitch_conga_refresh_mimic()
    local players = EntityGetWithTag("player_unit")
    for k=1,#players
    do v = players[k]
        local x,y = EntityGetTransform(v)
        local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_refresh_mimic.xml",x,y)
        EntityAddChild(v,c)
    end
end

