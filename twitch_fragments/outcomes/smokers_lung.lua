--Smoker's Lung
--Don't smoke kids
--lame
--80
--todo
function twitch_smokers_lung()
	add_icon_effect("mods/twitch-integration/files/effects/status_icons/cig_gas.png", "Smoker's Lung", "Let me finish my last 12 pack", 120*60, function()
		async(cig_smoke_effect)
	end)
end

function cig_smoke_effect()
	wait(5)
	local capacity = 7
	local pid
	
	repeat
		pid = get_player_nopoly()
		if pid > 0 then
			local player_data = EntityGetFirstComponent( get_player_nopoly(), "DamageModelComponent")
			capacity = ComponentGetValue2(player_data, "air_in_lungs_max")
		end
		wait(1)
	until pid > 0
	
	repeat
		pid = get_player_nopoly()
		if pid > 0 then
			local x, y = get_player_pos()
			
			GameCreateParticle("cigarete_smoke",x+1+rand(-1,1),y-9+rand(-1,1),rand(1,7), rand(-45,45), rand(-20,20), false)
			
			local player_data = EntityGetFirstComponent( get_player_nopoly(), "DamageModelComponent")
			local lung = ComponentGetValue2(player_data, "air_in_lungs")
			if lung > 0.35 then
				ComponentSetValue2(player_data, "air_in_lungs",0.35)
				ComponentSetValue2(player_data, "air_in_lungs_max", 0.8)
			end
		end
		wait(1)
	until not is_icon_effect_active("Smoker's Lung")
	
	repeat
		pid = get_player_nopoly()
		if pid > 0 then
			local player_data = EntityGetFirstComponent( get_player_nopoly(), "DamageModelComponent")
			capacity = ComponentSetValue2(player_data, "air_in_lungs_max", capacity)
		end
		wait(1)
	until pid > 0
end