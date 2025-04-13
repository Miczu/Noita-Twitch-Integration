--Immunity Nullification
--ResidentAmbrosia
--curses
--100
--You can no longer benefit from any immunities
function twitch_conga_immunity_nullification()
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

    local found = false
    local children = EntityGetAllChildren(player)
    for z=1,#children do
        if EntityGetName(children[z]) == "ti_event_immunity_cancel" then
            local comp = EntityGetFirstComponentIncludingDisabled(children[z],"GameEffectComponent")
            ComponentSetValue2(comp,"frames",ComponentGetValue2(comp,"frames") + 3600)
            found = true
            break
        end
    end
    if found == false then
        local x,y = EntityGetTransform(player)
        local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_immunity_cancel.xml",x,y)
        EntityAddChild(player,c)
    end
end

