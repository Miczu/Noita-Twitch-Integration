local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
local owner = EntityGetClosestWithTag(x, y, "mortal")

local lua_components = EntityGetComponent(owner, "LuaComponent")

if (lua_components ~= nil) then
    for _, component in ipairs(lua_components) do
        local damage_script_name = ComponentGetValue2(component, "script_shot")
        if (damage_script_name ~= nil and damage_script_name == "mods/twitch-integration/files/effects/moneyshot_effect.lua") then
            EntityRemoveComponent(owner, component)
        end
    end
end
local children = EntityGetAllChildren(owner)
if children then
    for _, child in ipairs(children) do
        local name = EntityGetName(child)
        if name == "moneyshot_icon" then
            EntityKill(child)
        end
    end
end