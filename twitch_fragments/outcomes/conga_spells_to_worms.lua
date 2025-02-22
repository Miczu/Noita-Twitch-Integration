--Spells 2 Worms
--I hope you like gardening
--curses
--100
--
function twitch_conga_spells_to_worms()
    local players = get_player_as_table()
    for k=1,#players
    do v = players[k]
        local x,y = EntityGetTransform(v)
        local found = false
        local children = EntityGetAllChildren(v)
        for z=1,#children do
            if EntityGetName(children[z]) == "ti_event_spells_to_worms" then
                local comp = EntityGetFirstComponentIncludingDisabled(children[z],"GameEffectComponent")
                ComponentSetValue2(comp,"frames",ComponentGetValue2(comp,"frames") + 900)
                found = true
                break
            end
        end
        if found == false then
            local x,y = EntityGetTransform(v)
            local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_spells_to_worms.xml",x,y)
            EntityAddChild(v,c)
        end
    end
end

