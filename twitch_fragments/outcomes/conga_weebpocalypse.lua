--Weebpocalypse
--The end times are here! Weebs have taken over!
--curses
--10
--Spawns an apocalypse of hentacle related hazards
function twitch_conga_weebpocalypse()
    local players = EntityGetWithTag("player_unit")
    for k=1,#players
    do v = players[k]
        local x,y = EntityGetTransform(v)
        local found = false
        local children = EntityGetAllChildren(v)
        for z=1,#children do
            if EntityGetName(children[z]) == "ti_event_weebpocalypse" then
                local comp = EntityGetFirstComponentIncludingDisabled(children[z],"GameEffectComponent")
                ComponentSetValue2(comp,"frames",ComponentGetValue2(comp,"frames") + 1800)
                found = true
                break
            end
        end
        if found == false then
            local x,y = EntityGetTransform(v)
            local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_weebpocalypse.xml",x,y)
            EntityAddChild(v,c)
            EntityLoad("mods/Twitch-integration/files/entities/particles/image_emitters/magical_symbol_materia_fungus.xml",x,y)
            GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/greed_curse/create", x,y )
        end
    end
end

