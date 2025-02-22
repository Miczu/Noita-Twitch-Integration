--Delusional
--You're seeing things old man
--curses
--200
--
function twitch_conga_delusional()
    local players = get_player_as_table()
    for k=1,#players
    do v = players[k]
        local x,y = EntityGetTransform(v)
        local found = false
        local children = EntityGetAllChildren(v)
        for z=1,#children do
            if EntityGetName(children[z]) == "apotheosis_delusional" then
                local comp = EntityGetFirstComponentIncludingDisabled(children[z],"GameEffectComponent")
                ComponentSetValue2(comp,"frames",ComponentGetValue2(comp,"frames") + 3600)
                found = true
                break
            end
        end
        if found == false then
            local x,y = EntityGetTransform(v)
            local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_delusional.xml",x,y)
            EntityAddChild(v,c)
        end
    end
end

