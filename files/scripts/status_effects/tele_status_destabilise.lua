
local entity_id    = GetUpdatedEntityID()
local player_id = EntityGetRootEntity(entity_id)

local TeleTest = GameGetGameEffectCount( player_id, "TELEPORTATION" )

--Destabilise Teleportitis
if TeleTest ~= 0 then
	local comp = GameGetGameEffect( player_id, "TELEPORTATION" )
	if comp ~= 0 then
		ComponentSetValue2 ( comp, "effect", "UNSTABLE_TELEPORTATION" )
	end
end