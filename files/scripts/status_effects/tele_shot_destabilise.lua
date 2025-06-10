dofile_once("data/scripts/lib/utilities.lua")

function shot( entity_id )
	local pos_x, pos_y = EntityGetTransform( entity_id )
	
	local shouldDestabilise = false
	
	local tcomps = EntityGetComponentIncludingDisabled(entity_id,"TeleportProjectileComponent")
	local scomps = EntityGetComponentIncludingDisabled(entity_id,"HitEffectComponent")
	if tcomps then
		shouldDestabilise = true
	end
	if scomps then
		for k=1,#scomps
        do local v = scomps[k]
            if ComponentGetValue2(v,"effect_hit") == "SWAPPER" then
                shouldDestabilise = true
            end
        end
	end
	
	if shouldDestabilise then
		edit_component( entity_id, "VelocityComponent", function(comp,vars)
			local vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity")
		
			local angle = math.deg(0 - math.atan2( vel_y, vel_x ))
			local dist = math.sqrt( vel_y ^ 2 + vel_x ^ 2 )
			angle = math.random(0,360)
			angle = math.rad(angle)
	
			vel_x = math.cos( angle ) * dist
			vel_y = 0 - math.sin( angle ) * dist
		
			ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y)
		end)
	end
end