--Delusional
--You're seeing things old man
--curses
--200
--
function twitch_conga_delusional()
    local players = EntityGetWithTag("player_unit")
    for k=1,#players
    do v = players[k]
        local x,y = EntityGetTransform(v)
        local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_delusional.xml",x,y)
        EntityAddChild(v,c)
    end
end

