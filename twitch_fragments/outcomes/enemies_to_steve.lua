--Steve gang
--anyone got some anti dandruff !?!?
--curses
--5
--todo

function twitch_enemies_to_steve()
    async(effect_enemies_to_steve)
end

function effect_enemies_to_steve()
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

    if (player) then
        local x, y = get_player_pos()
        local thingy = EntityLoad("mods/twitch-integration/files/effects/steve.xml", x, y)
        EntityAddComponent2( thingy, "UIIconComponent",
            {
                name = "Steveland",
                description = "yikes",
                icon_sprite_file = "mods/twitch-integration/files/effects/status_icons/randenemy.png",
                display_above_head = false,
                display_in_hud = true,
                is_perk = false
            })
        EntityAddChild(player, thingy)
    end
end