local entity_id = GetUpdatedEntityID()
local player_id = EntityGetRootEntity(entity_id)

--Remove child as it's no longer needed
EntityKill(entity_id)