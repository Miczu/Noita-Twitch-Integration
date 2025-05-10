--Random enemies
--a new wave every 5 seconds yay
--curses
--40
--todo

function twitch_randomize_enemies()
    async(effect_randomize_enemies)
end

function effect_randomize_enemies()
    
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

    if (player) then
        local x, y = get_player_pos()
        local thingy = EntityLoad("mods/twitch-integration/files/effects/randomizer.xml", x, y)
        EntityAddComponent2( thingy, "UIIconComponent",
            {
                name = "Random Enemies",
                description = "might be scuffed",
                icon_sprite_file = "mods/twitch-integration/files/effects/status_icons/randenemy.png",
                display_above_head = false,
                display_in_hud = true,
                is_perk = false
            })
        EntityAddChild(player, thingy)
    end
end