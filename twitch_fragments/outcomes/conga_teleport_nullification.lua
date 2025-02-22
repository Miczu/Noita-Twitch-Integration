--Teleport Nullification
--Does what it says
--curses
--100
--You can no longer teleport
function twitch_conga_teleport_nullification()
    local players = get_player_as_table()
    for k=1,#players
    do v = players[k]
        local found = false
        local children = EntityGetAllChildren(v)
        for z=1,#children do
            if EntityGetName(children[z]) == "apotheosis_teleport_cancel" then
                local comp = EntityGetFirstComponentIncludingDisabled(children[z],"GameEffectComponent")
                ComponentSetValue2(comp,"frames",ComponentGetValue2(comp,"frames") + 3600)
                found = true
                break
            end
        end
        if found == false then
            local x,y = EntityGetTransform(v)
            local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_teleport_cancel.xml",x,y)
            EntityAddChild(v,c)
        end
    end
end

