--Upgrade Enemies
--Enemies feel a bit stronger...
--curses
--69
--todo
function twitch_upgrade_enemies()
    async(effect_upgrade_enemies)
end

function effect_upgrade_enemies()
    
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

    if (player) then
        local x, y = get_player_pos()
        local thingy = EntityLoad("mods/twitch-integration/files/effects/upgrade_enemies.xml", x, y)
        EntityAddComponent2( thingy, "UIIconComponent",
            {
                name = "Upgraded Enemies",
                description = "Enemies feel a bit stronger...",
                icon_sprite_file = "mods/twitch-integration/files/effects/status_icons/enemy_upgrade.png",
                display_above_head = false,
                display_in_hud = true,
                is_perk = false
            })
        EntityAddChild(player, thingy)
    end
end