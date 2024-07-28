--Bleeding
--I think you might need a bandage
--lame
--160
--todo
function twitch_bleeding()
	local name = "Bleeding"
	add_icon_effect("data/ui_gfx/status_indicators/bloody.png", name, "I think you might need a bandage", 100*60, function()
	counter = 69
	async(function()
			local x, y = get_player_pos()
			local player_entity = get_player()
			local percent_to_remove = 0.01;
			local conditionMin = 0
			local conditionMax = 32
			local condition = rand(conditionMin,conditionMax)
			
			repeat
				x, y = get_player_pos()
				LoadPixelScene("mods/twitch-integration/files/pixel_scenes/bleeding.png","",x-8 , y-11, "", true)
				counter = counter + 1
				if counter > condition then
					local damage_models = EntityGetComponent(player_entity,"DamageModelComponent") or {};
					local hp = 0;
					for _, damage_model in pairs(damage_models) do
						hp = hp + ComponentGetValue(damage_model, "hp");
					end
					x, y = get_player_pos()
					local take_damage = EntityLoad("data/entities/misc/area_damage.xml", x, y);
					local area_damage = EntityGetFirstComponent(take_damage,"AreaDamageComponent");
					ComponentSetValue(area_damage, "entities_with_tag", "player_unit");
					ComponentSetValue(area_damage, "damage_per_frame", hp * percent_to_remove);
					ComponentSetValue(area_damage, "damage_type", "DAMAGE_CURSE");
					EntityAddComponent(take_damage, "LifetimeComponent", {lifetime = 2});
					counter = 1
					condition = rand(conditionMin,conditionMax)
				end
				wait(rand(60, 180))
			until not is_icon_effect_active(name)
		end)
	end)
end
