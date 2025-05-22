--Grounded
--jump jump jump
--curses
--40
--todo

function twitch_grounded()
    local player = get_player()
    if (player) then
        local x, y = get_player_pos()
        local thingy = EntityCreateNew("grounded")
        EntityAddComponent2( thingy, "UIIconComponent",
            {
                name = "Steveland",
                description = "yikes",
                icon_sprite_file = "mods/twitch-integration/files/effects/status_icons/grounded.png",
                display_above_head = true,
                display_in_hud = true,
                is_perk = true
            })
        EntityAddComponent2( thingy, "LifetimeComponent",
            {
                lifetime = 60 * 7
            })
        EntityAddChild(player, thingy)
    end
    async(function()
        local duration = 60 * 6
        local player_data = EntityGetFirstComponent( get_player(), "CharacterDataComponent")
    
        while player_data == nil do
            wait(60)
            player_data = EntityGetFirstComponent( get_player(), "CharacterDataComponent")
        end
        
        local flytime = ComponentGetValue2(player_data, "mFlyingTimeLeft")
        local recharge = ComponentGetValue2(player_data, "fly_recharge_spd_ground")
        local recharge2 = ComponentGetValue2(player_data, "fly_recharge_spd")
        ComponentSetValue2(player_data, "mFlyingTimeLeft",0)
        while recharge == 0 do
            wait(60)
            recharge = ComponentGetValue2(player_data, "fly_recharge_spd_ground")
        end
        ComponentSetValue2(player_data, "fly_recharge_spd_ground", 0)
        ComponentSetValue2(player_data, "fly_recharge_spd",0)
        wait(duration)
    
        ComponentSetValue2(player_data, "fly_recharge_spd_ground", recharge)
        ComponentSetValue(player_data, "fly_recharge_spd", recharge2)
    end)
end