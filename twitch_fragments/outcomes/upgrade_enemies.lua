--Upgrade Enemies
--Some enemies feel different...
--curses
--68
--todo
function twitch_upgrade_enemies()
    async(effect_upgrade_enemies)
end

function effect_upgrade_enemies()
    local player
    repeat
        wait(1)
        player = get_player_nopoly()
    until player > 0

    if player then
        local found = false
        local children = EntityGetAllChildren(player) or {}
        for i = 1, #children do
            if EntityGetName(children[i]) == "upgrade_enemies_effect" then
                local comp = EntityGetFirstComponentIncludingDisabled(
                    children[i], "GameEffectComponent"
                )
                if comp then
                    local frames = ComponentGetValue2(comp, "frames")
                    ComponentSetValue2(comp, "frames", frames + 3600)
                end
                found = true
                break
            end
        end
        if not found then
            local x, y = EntityGetTransform(player)
            local effect = EntityLoad("mods/twitch-integration/files/effects/upgrade_enemies.xml", x, y)
            EntitySetName(effect, "upgrade_enemies_effect")
            EntityAddComponent2(effect, "UIIconComponent", {
                name = "Upgraded Enemies",
                description = "Enemies feel a bit stronger...",
                icon_sprite_file = "mods/twitch-integration/files/effects/status_icons/enemy_upgrade.png",
                display_above_head = false,
                display_in_hud = true,
                is_perk = false,
            })
            EntityAddChild(player, effect)
        end
    end
end
