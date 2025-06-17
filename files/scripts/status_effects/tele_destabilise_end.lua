
local entity_id    = GetUpdatedEntityID()
local player_id = EntityGetRootEntity(entity_id)

--Enable Teleportitis Perk
if GameGetGameEffectCount( player_id, "UNSTABLE_TELEPORTITIS" ) ~= 0 then
    local comp = GameGetGameEffect( player_id, "UNSTABLE_TELEPORTITIS" )
    if comp ~= 0 then
        if ComponentGetValue2( comp, "custom_effect_id") == "UNSTABLE_TELEPORTITIS" then
            ComponentSetValue2( comp, "effect", "TELEPORTITIS")
            ComponentSetValue2( comp, "custom_effect_id", "")
        end
    end
end

--Remove Unstable Teleportitis effect
local lua_components = EntityGetComponent(player_id, "LuaComponent")

if (lua_components ~= nil) then
	for _, component in ipairs(lua_components) do
		local damage_script_name = ComponentGetValue2(component, "script_damage_received")
		if (damage_script_name ~= nil and damage_script_name == "mods/twitch-integration/files/scripts/status_effects/unstable_teleportitis.lua") then
			EntityRemoveComponent(player_id, component)
		end
	end
end