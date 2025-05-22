--Teleport Beacon
--This place is calling for me
--bad_effects
--100
--When teleported, you go to beacon instead
function twitch_teleport_beacon()
	local x, y = get_player_pos()
    EntityLoad("data/entities/teleport_beacon.xml", x, y)
	GlobalsSetValue( "beacon_last_x", x )
	GlobalsSetValue( "beacon_last_y", y )

	add_icon_effect("mods/twitch-integration/files/effects/status_icons/teleportitis_beacon.png", "Teleport Beacon", "I'm being guided to familar place", 40*60, function()
		async(beacon_check
	)
	end)
end

function beacon_check()
	wait(5)
	local oldX, oldY = get_player_pos()
	repeat
		local pid = get_player()
		if pid ~= nil then
			local cid = EntityGetFirstComponent(pid, "VelocityComponent")
			
			local x, y = get_player_pos()
			local vx, vy = ComponentGetValue2(cid, "mVelocity")
			if did_teleport(x, y, oldX, oldY, vx, vy) then
				wait(5)
				
				local beacon_x = GlobalsGetValue( "beacon_last_x", 0 )
				local beacon_y = GlobalsGetValue( "beacon_last_y", 0 )
				EntitySetTransform(pid, beacon_x, beacon_y)

				oldX = beacon_x
				oldY = beacon_y
			else
				oldX = x
				oldY = y
			end
		end
		wait(0)
	until not is_icon_effect_active("Teleport Beacon")
end
