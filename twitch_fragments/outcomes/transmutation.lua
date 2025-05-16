--Transmutation
--Yea idk alchemy i guess
--curses
--150
--idk fml
function twitch_transmutation()
    local player = get_player()
    local x, y = get_player_pos()

    local effect_id = EntityLoad("data/scripts/streaming_integration/entities/transmutation.xml", x, y)
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
            name = "$streamingevent_transmutation",
            description = "$streamingeventdesc_transmutation",
            icon_sprite_file = "data/ui_gfx/status_indicators/radioactive.png",
            display_above_head = false,
            display_in_hud = true,
            is_perk = false
        }
    )
    EntityAddChild( player, effect_id )
end
