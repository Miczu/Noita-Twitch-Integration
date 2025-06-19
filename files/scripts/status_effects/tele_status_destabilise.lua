
local entity_id    = GetUpdatedEntityID()
local player_id = EntityGetRootEntity(entity_id)

local TeleTest = GameGetGameEffectCount( player_id, "TELEPORTATION" )

--Destabilise Teleportation status effects
if TeleTest ~= 0 then
	local comp = GameGetGameEffect( player_id, "TELEPORTATION" )
	if comp ~= 0 then
		ComponentSetValue2 ( comp, "effect", "UNSTABLE_TELEPORTATION" )
	end
end

--Check if teleportitis perk exists (in case this begins just before tele cancel ends)
if GameGetGameEffectCount( player_id, "TELEPORTITIS" ) ~= 0 then
    dofile_once("mods/Twitch-integration/files/scripts/status_effects/tele_destabilise_start.lua")
end