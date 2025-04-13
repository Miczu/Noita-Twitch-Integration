--Weebpocalypse
--The end times are here! Weebs have taken over!
--curses
--10
--Spawns an apocalypse of hentacle related hazards
function twitch_conga_weebpocalypse()
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

    local x,y = EntityGetTransform(player)
    local found = false
    local children = EntityGetAllChildren(player)
    for z=1,#children do
        if EntityGetName(children[z]) == "ti_event_weebpocalypse" then
            local comp = EntityGetFirstComponentIncludingDisabled(children[z],"GameEffectComponent")
            ComponentSetValue2(comp,"frames",ComponentGetValue2(comp,"frames") + 1800)
            found = true
            break
        end
    end
    if found == false then
        local x,y = EntityGetTransform(player)
        local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_weebpocalypse.xml",x,y)
        EntityAddChild(player,c)
        EntityLoad("mods/Twitch-integration/files/entities/particles/image_emitters/magical_symbol_materia_fungus.xml",x,y)
        GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/greed_curse/create", x,y )
    end
end

