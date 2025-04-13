--Spiderman
--leggy day
--curses
--100
--todo
function twitch_spiderman()
	local lukki_count_true = GlobalsGetValue( "PERK_PICKED_ATTACK_FOOT_PICKUP_COUNT","0")
	local lukki_transformation_progress_true = GlobalsGetValue( "PLAYER_LUKKINESS_LEVEL","0")
	local x, y = get_player_pos()
	local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

	if player ~= nil then
		local perk_entity = perk_spawn(x, y - 8, "ATTACK_FOOT")
		perk_pickup(perk_entity, player, nil, true, false)
		local perk_removal = EntityLoad("mods/twitch-integration/files/effects/spiderman.xml")
		EntityAddChild(player, perk_removal)
	end
    for _, entity in pairs(EntityGetInRadiusWithTag(x, y, 1024, "enemy") or {}) do			
		if(EntityHasTag(entity, "boss_centipede") == false or EntityHasTag(entity, "boss_centipede_active") == true) then
			if EntityGetIsAlive(entity) == true then
				local ex, ey = EntityGetTransform(entity)
				local enemy_perk = perk_spawn(ex, ey - 8, "ATTACK_FOOT")
				perk_pickup(enemy_perk, entity, nil, true, false)
			end
		end
    end

	--Restore true lukki perks taken count
	GlobalsSetValue( "PERK_PICKED_ATTACK_FOOT_PICKUP_COUNT",lukki_count_true)
	GlobalsSetValue( "PLAYER_LUKKINESS_LEVEL",lukki_transformation_progress_true)
end
