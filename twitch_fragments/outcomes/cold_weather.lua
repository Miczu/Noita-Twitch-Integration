--Cold Weather
--Stay warm
--enviromental
--110
--todo
function twitch_cold_weather()
    async(function()
        while true do
            wait(6)
            player_data = EntityGetFirstComponent( get_player(), "CharacterDataComponent")
            if (player_data ~= nil) then                
                local flytime = ComponentGetValue2(player_data, "mFlyingTimeLeft")
                local flyMax = ComponentGetValue2(player_data, "fly_time_max")
                if (flytime == flyMax) then
                    spawn_item_in_range("data/entities/projectiles/deck/sea_ice.xml", 0, 0, 0, 15, 0, 1, false)
                    return;
                end
            end            
        end
    end)
end
