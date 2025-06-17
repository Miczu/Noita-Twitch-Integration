
local entity_id    = GetUpdatedEntityID()
local player_id = EntityGetRootEntity(entity_id)

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

--check if teleport cancel is still active
local tele_canceled = false
local children = EntityGetAllChildren(player_id)
for z=1,#children do
	if EntityGetName(children[z]) == "apotheosis_teleport_cancel" then
		tele_canceled = true
		break
	end
end
if tele_canceled == false then
	--Enable Teleportitis Perk
	if GameGetGameEffectCount( player_id, "CUSTOM" ) ~= 0 then
		local comp = GameGetGameEffect( player_id, "CUSTOM" )
		if comp ~= 0 then
			if ComponentGetValue2( comp, "custom_effect_id") == "TELEPORTITIS_DISABLED" then
				ComponentSetValue2( comp, "effect", "TELEPORTITIS")
				ComponentSetValue2( comp, "custom_effect_id", "")
			end
		end
	end
end