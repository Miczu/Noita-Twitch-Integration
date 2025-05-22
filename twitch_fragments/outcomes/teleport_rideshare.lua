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
		local pid = get_player()
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
