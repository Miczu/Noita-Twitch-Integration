--Teleport Rideshare
--I'm feeling like giving random strangers a ride
--curses
--100
--Nearby creatures will teleport with player
function twitch_teleport_rideshare()
	add_icon_effect("mods/twitch-integration/files/effects/status_icons/teleportitis_BAD2.png", "Teleport Rideshare", "I'm feeling like giving random strangers a ride", 120*60, function()
		async(rideshare)
	end)
end

function rideshare()
	wait(5)
	local oldX, oldY = get_player_pos()
	repeat
		local pid = get_player_event()
		if pid ~= nil then
			local cid = EntityGetFirstComponent(pid, "VelocityComponent")
			
			local x, y = get_player_pos()
			local vx, vy = ComponentGetValue2(cid, "mVelocity")
			if did_teleport(x, y, oldX, oldY, vx, vy) then
				local enemies = EntityGetInRadiusWithTag(oldX, oldY, 160, "enemy")
				wait(12)
				local nx, ny = get_player_pos()
				for _, entity in pairs(enemies or {}) do
					shoot_tele(entity, pid, nx, ny)
				end
				oldX = nx
				oldY = ny
			else
				oldX = x
				oldY = y
			end
		end
		wait(0)
	until not is_icon_effect_active("Teleport Rideshare")
end

function did_teleport(newX, newY, oldX, oldY, vx, vy)
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
	local ignoreRadius = 50
	for _, p in ipairs(portal_destinations) do
        local dx_portal = newX - p.x
        local dy_portal = newY - p.y
        if (dx_portal*dx_portal + dy_portal*dy_portal) <= (ignoreRadius*ignoreRadius) then
            return false
        end
    end
	local jump = 30
	jump = jump * jump;
	
	local dx = math.min(math.pow(oldX - newX, 2), math.pow(oldX - newX - vx, 2));
	local dy = math.min(math.pow(oldY - newY, 2), math.pow(oldY - newY - vy, 2));

	return ((dx+dy) > jump)
end

function shoot_tele( who_shot, pid, x, y )
	local angle = math.random(0, 314) / 100 * math.pi * 2
	local sx, sy = math.cos(angle)*6,
				   -math.sin(angle)*6;

	local entity_id = EntityLoad( "data/entities/projectiles/deck/teleport_projectile.xml", x+sx, y+sy )

	GameShootProjectile( who_shot, x+sx, y+sy, sx*2+x, sy*2+y, entity_id )

	local herd_id   = get_herd_id( pid )
	edit_component( entity_id, "ProjectileComponent", function(comp,vars)
		vars.mWhoShot       = who_shot
		vars.mShooterHerdId = herd_id
	end)

	return entity_id
end
