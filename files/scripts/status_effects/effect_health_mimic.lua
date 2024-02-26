
local entity_id = GetUpdatedEntityID()
local player = EntityGetParent(entity_id)
local x, y = EntityGetTransform( entity_id )

local targets = EntityGetWithTag( "drillable" ) or {}

local comp = EntityGetFirstComponentIncludingDisabled(player,"DamageModelComponent")
local hp = ComponentGetValue2(comp,"hp")
local safelock = false

--If Streamer is at or below 80 health, force it to be a refresh mimic
--We run the check here incase chat votes for a health mimic, then he takes a ton of damage, and needs a heal later
if hp <= 3.2 then
    local players = EntityGetWithTag("player_unit")
    for k=1,#players
    do v = players[k]
		local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_refresh_mimic.xml",x,y)
		EntityAddChild(v,c)
	end

	EntityRemoveFromParent(entity_id)
	EntityKill(entity_id)
	safelock = true
end

if ( #targets > 0 ) and safelock == false then
    for k=1,#targets
    do local v = targets[k]
		local comp = EntityGetFirstComponentIncludingDisabled(v,"LuaComponent")
		if ComponentGetValue2(comp,"script_item_picked_up") == "data/scripts/items/heart_fullhp_temple.lua" then
			local s_x, s_y = EntityGetTransform(v)
			EntityKill(v)
			EntityLoad("mods/Twitch-integration/files/entities/animals/dark_alchemist_noprogress.xml",s_x,s_y)
			EntityRemoveFromParent( entity_id )
			EntityKill(entity_id)
			break
		end
	end
end
