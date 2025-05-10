--Blazing Enemies
--Everyone took a lesson from stendari
--curses
--119
--Every enemy is set on fire, becomes immune to fire and tries to set you on fire
function twitch_blazing_enemies()
    async(effect_blazing_enemies)
end

function effect_blazing_enemies()
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

    local x,y = EntityGetTransform(player)
    local found = false
    local children = EntityGetAllChildren(player)
    for z=1,#children do
        if EntityGetName(children[z]) == "ti_effect_blazing_enemies" then
            local comp = EntityGetFirstComponentIncludingDisabled(children[z],"GameEffectComponent")
            ComponentSetValue2(comp,"frames",ComponentGetValue2(comp,"frames") + 3600)
            found = true
            break
        end
    end
    if found == false then
        local x,y = EntityGetTransform(player)
        local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_blazing_enemies.xml",x,y)
        EntityAddChild(player,c)
    end
end

