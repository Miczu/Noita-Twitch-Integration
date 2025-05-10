--Delusional
--You're seeing things old man
--curses
--200
--
function twitch_conga_delusional()
    async(effect_conga_delusional)
end

function effect_conga_delusional()
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

    local x,y = EntityGetTransform(player)
    local found = false
    local children = EntityGetAllChildren(player)
    for z=1,#children do
        if EntityGetName(children[z]) == "apotheosis_delusional" then
            local comp = EntityGetFirstComponentIncludingDisabled(children[z],"GameEffectComponent")
            ComponentSetValue2(comp,"frames",ComponentGetValue2(comp,"frames") + 3600)
            found = true
            break
        end
    end
    if found == false then
        local x,y = EntityGetTransform(player)
        local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_delusional.xml",x,y)
        EntityAddChild(player,c)
    end
end

