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
        math.randomseed(x+y)
        local c = 0

        --20% chance for a health mimic
        --80% chance for a refresh mimic
        if math.random(1,10) <= 2 then
            c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_health_mimic.xml",x,y)
        else
            c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_refresh_mimic.xml",x,y)
        end
        EntityAddChild(v,c)
    end
end

