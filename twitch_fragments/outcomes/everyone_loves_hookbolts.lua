--Everyone Loves Hookbolts
--Everyone Loves Hookbolts
--curses
--90
--
function twitch_everyone_loves_hookbolts()
    local players = EntityGetWithTag("player_unit")
    for k=1,#players
    do v = players[k]
        local x,y = EntityGetTransform(player)
        local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_everyone_loves_hookbolts.xml",x,y)
        EntityAddChild(v,c)
    end

    GlobalsSetValue("TI_randomproj","deck/hook")
    GlobalsSetValue("TI_randomprojicon","everyone_loves_hookbolts.png")
    GlobalsSetValue("TI_randomprojthreat",2)
end

