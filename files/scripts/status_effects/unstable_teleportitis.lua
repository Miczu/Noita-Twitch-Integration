function damage_received( damage, message, entity_thats_responsible, is_fatal)
	local entity_id    = GetUpdatedEntityID()
	local player_id = EntityGetRootEntity(entity_id)
	--Check for unstable teleportitis
	if GameGetGameEffectCount( player_id, "UNSTABLE_TELEPORTITIS" ) ~= 0 then
		local comp = GameGetGameEffect( player_id, "UNSTABLE_TELEPORTITIS" )
		if comp ~= 0 then
			--check if teleport cancel is in effect
			local tele_canceled = false
			EntityGetAllChildren(player_id)
			for z=1,#children do
				if EntityGetName(children[z]) == "apotheosis_teleport_cancel" then
					tele_canceled = true
					break
				end
			end
			
			if not tele_canceled then
				local game_effect = GetGameEffectLoadTo(player_id, "UNSTABLE_TELEPORTATION", true);
				if game_effect ~= nil then 
					ComponentSetValue(game_effect, "frames", 3)
					ComponentSetValue(game_effect, "teleportation_probability", 1)
					ComponentSetValue(game_effect, "teleportation_delay_min_frames", 2)
				end
			end
		end
	end
end