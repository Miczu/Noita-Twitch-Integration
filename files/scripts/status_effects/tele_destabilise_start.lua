local entity_id    = GetUpdatedEntityID()
local player_id = EntityGetRootEntity(entity_id)

--Destabilise Teleportitis Perk
if GameGetGameEffectCount( player_id, "TELEPORTITIS" ) ~= 0 then
    local comp = GameGetGameEffect( player_id, "TELEPORTITIS" )
    if comp ~= 0 then
        ComponentSetValue2( comp, "effect", "CUSTOM")
        ComponentSetValue2( comp, "custom_effect_id", "TELEPORTITIS_DISABLED")
		EntityAddComponent( player_id, "LuaComponent", {
			enable_coroutines = "1",
			execute_every_n_frame = "-1",
			limit_to_every_n_frame = "59",
			limit_all_callbacks = "true",
			script_damage_received = "mods/twitch-integration/files/scripts/status_effects/unstable_teleportitis.lua"
		})
    end
end