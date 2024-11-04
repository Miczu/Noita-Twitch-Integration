
local entity_id = GetUpdatedEntityID()
local player = EntityGetParent(entity_id)
local x, y = EntityGetTransform( entity_id )

local portal_id = 0

local targets = EntityGetInRadius( x, y, 128 ) or {}

if ( #targets > 0 ) then
    for k=1,#targets
    do local v = targets[k]
		local comp = EntityGetFirstComponentIncludingDisabled(v,"UIInfoComponent") or 0
		if comp ~= 0 and (ComponentGetValue2(comp,"name") == "$teleport_deeper" or ComponentGetValue2(comp,"name") == "$teleport_ending") then --Conga the portal to the laboratory is red and the mimic will be crazy obvious as is but I don't have the time to fix it right now; I feel this change is better than chat being scammed out of a portal mimic entirely however
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