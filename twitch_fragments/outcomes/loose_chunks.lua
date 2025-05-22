--Loose Chunks
--Watch your head
--curses
--130
--idk fml
function twitch_loose_chunks()
    local player = get_player()
    local x, y = get_player_pos()

    local effect_id = EntityLoad("mods/twitch-integration/files/effects/earthquake_curse.xml", x, y)
    local comps = EntityGetComponent(effect_id, "LifetimeComponent")
    if (comps ~= nil) then
		for i,v in ipairs(comps) do
			ComponentSetValue2( v, "lifetime", 60*60 )
		end
    end
    EntityAddComponent2(
        effect_id,
        "UIIconComponent",
        {
            name = "Loose Chunks",
            description = "Watch your head",
            icon_sprite_file = "data/ui_gfx/gun_actions/crumbling_earth.png",
            display_above_head = false,
            display_in_hud = true,
            is_perk = false
        }
    )
    EntityAddChild( player, effect_id )
end
