--Teleport Nullification
--Does what it says
--curses
--100
--You can no longer teleport
function twitch_conga_teleport_nullification()
    local players = EntityGetWithTag("player_unit")
    for k=1,#players
    do v = players[k]
        local x,y = EntityGetTransform(v)
        local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_teleport_cancel.xml",x,y)
        EntityAddChild(v,c)
    end
end

