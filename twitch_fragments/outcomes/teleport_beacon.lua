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
local idx = -1
function beacon_check()
	wait(5)
	local oldX, oldY = get_player_pos()
	repeat
		local pid = get_player_event()
		if pid ~= nil then
			local cid = EntityGetFirstComponent(pid, "VelocityComponent")
			
			local x, y = get_player_pos()
			local vx, vy = ComponentGetValue2(cid, "mVelocity")
			yesTele, idx = did_teleport_beacon(x, y, oldX, oldY, vx, vy, idx)
			if yesTele then
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
function did_teleport_beacon(newX, newY, oldX, oldY, vx, vy,prevIdx)
	local portal_destinations = {
		{x=-677,y=1350,idx=0}, --coalpits
		{x=-677,y=2886,idx=1}, --snowy
		{x=-677,y=4934,idx=2}, --hiisi
		{x=-677,y=6470,idx=3}, --jungle
		{x=-677,y=8518,idx=4}, --vault
		{x=-677,y=10566,idx=5}, --temple
		{x=1910,y=13100,idx=6}, --lab
		{x=6220,y=15175,idx=7}, --winning area
		{x=764,y=-814,idx=8} -- note/tower portal
		-- could add the other niche portal locations here but who's gonna actually use them in TI
	}
	local ignoreRadius = 25
	local thisIdx = -1
	local portalEntered = false
	for _, p in ipairs(portal_destinations) do
        local dx_portal = newX - p.x
        local dy_portal = newY - p.y
        if (dx_portal*dx_portal + dy_portal*dy_portal) <= (ignoreRadius*ignoreRadius) then
			thisIdx = p.idx
			portalEntered = true
			if (p.idx == prevIdx) then
				return false, thisIdx
			end
			break
        end
    end
	local jump = 30
	jump = jump * jump;
	
	local dx = math.min(math.pow(oldX - newX, 2), math.pow(oldX - newX - vx, 2));
	local dy = math.min(math.pow(oldY - newY, 2), math.pow(oldY - newY - vy, 2));
	if portalEntered then
		return ((dx+dy) > jump), (thisIdx ~= -1) and thisIdx or prevIdx
	end
	return ((dx+dy) > jump), ((dx+dy) > jump) and -1 or prevIdx
end
