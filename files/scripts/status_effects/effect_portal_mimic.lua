
local entity_id = GetUpdatedEntityID()
local player = EntityGetParent(entity_id)
local x, y = EntityGetTransform( entity_id )

local portal_id = 0

local targets = EntityGetInRadius( x, y, 128 ) or {}

if ( #targets > 0 ) then
    for k=1,#targets
    do local v = targets[k]
		local comp = EntityGetFirstComponentIncludingDisabled(v,"UIInfoComponent") or 0
		if comp ~= 0 and ComponentGetValue2(comp,"name") == "$teleport_deeper" then
			portal_id = v
			break
		end
	end
end

if portal_id ~= 0 then
	local output = "mods/Twitch-integration/files/entities/animals/portal_mimic_noprogress.xml"

	local s_x, s_y = EntityGetTransform(portal_id)
	EntityKill(portal_id)
	EntityLoad(output,s_x,s_y)
	EntityRemoveFromParent(entity_id)
	EntityKill(entity_id)

end