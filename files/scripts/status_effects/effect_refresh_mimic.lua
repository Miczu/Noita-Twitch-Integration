
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local targets = EntityGetWithTag( "drillable" ) or {}

if ( #targets > 0 ) then
    for k=1,#targets
    do local v = targets[k]
		local comp = EntityGetFirstComponentIncludingDisabled(v,"LuaComponent")
		if ComponentGetValue2(comp,"script_item_picked_up") == "data/scripts/items/spell_refresh.lua" then
			local s_x, s_y = EntityGetTransform(v)
			EntityKill(v)
			EntityLoad("mods/Twitch-integration/files/entities/animals/shaman_wind_noprogress.xml",s_x,s_y)
			EntityRemoveFromParent( entity_id )
			EntityKill(entity_id)
			break
		end
	end
end
