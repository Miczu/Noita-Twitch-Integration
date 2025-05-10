--Spells 2 Worms
--I hope you like gardening
--curses
--100
--
function twitch_conga_spells_to_worms()
    async(effect_conga_spells_to_worms)
end

function effect_conga_spells_to_worms()
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

    local x,y = EntityGetTransform(player)
    local found = false
    local children = EntityGetAllChildren(player)
    for z=1,#children do
        if EntityGetName(children[z]) == "ti_event_spells_to_worms" then
            local comp = EntityGetFirstComponentIncludingDisabled(children[z],"GameEffectComponent")
            ComponentSetValue2(comp,"frames",ComponentGetValue2(comp,"frames") + 900)
            found = true
            break
        end
    end
    if found == false then
        local x,y = EntityGetTransform(player)
        local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_spells_to_worms.xml",x,y)
        EntityAddChild(player,c)
    end
end

