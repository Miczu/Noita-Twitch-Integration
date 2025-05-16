--Spicy Blood
--You should see a doctor about that
--curses
--100
--Enemies can have lava, acid or polymorphine blood
function twitch_conga_spicyblood()
    async(effect_conga_spicyblood)
end

function effect_conga_spicyblood()
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

    local x,y = EntityGetTransform(player)

    
    SetRandomSeed(x,y)
    local rng = Random(1,100)
    if rng > 20 then
        blood = "acid"
    elseif rng > 2 then
        blood = "lava"
    else
        blood = "magic_liquid_random_polymorph"
    end
    GlobalsSetValue("ti_spicyblood_type",tostring(blood))

    local children = EntityGetAllChildren(player)
    local found = false
    for k=1,#children do
        local v = children[k]
        if EntityGetName(v) == "ti_spicyblood_ui_timer" then
            found = v
            break
        end
    end

    if found ~= false then
        local ui_comp = EntityGetFirstComponentIncludingDisabled(found,"UIIconComponent")
        ComponentSetValue2(ui_comp,"icon_sprite_file","mods/Twitch-integration/files/ui_gfx/status_indicators/spicyblood_" .. blood ..".png")

        local game_comp = EntityGetFirstComponentIncludingDisabled(found,"GameEffectComponent")
        local timer = ComponentGetValue2(game_comp,"frames")
        ComponentSetValue2(game_comp,"frames",timer + 2700)
    else
        local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_spicyblood.xml",x,y)
        EntityAddChild(player,c)

        EntityAddComponent2(c,"UIIconComponent",{
            name="Spicy Blood",
            description="Enemies are bleeding something wild!",
            icon_sprite_file="mods/Twitch-integration/files/ui_gfx/status_indicators/spicyblood_" .. blood ..".png",
            is_perk = false,
            display_above_head = false,
            display_in_hud = true
        })
    end
end
