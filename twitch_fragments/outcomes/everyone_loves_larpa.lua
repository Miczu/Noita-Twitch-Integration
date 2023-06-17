--Everyone Loves Larpa
--Everyone Loves Larpa
--curses
--40
--
function twitch_everyone_loves_larpa()
    local players = EntityGetWithTag("player_unit")
    for k=1,#players
    do v = players[k]
        local x,y = EntityGetTransform(player)
        local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_everyone_loves_larpa.xml",x,y)
        EntityAddChild(v,c)
    end
end

