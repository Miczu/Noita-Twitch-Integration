dofile("data/scripts/lib/utilities.lua")
local entity_id = GetUpdatedEntityID()
local player = EntityGetParent(entity_id)
local x, y = EntityGetTransform(entity_id)

edit_component(GameGetWorldStateEntity(), "WorldStateComponent", function(comp, vars)
    vars.damage_flash_multiplier = 3.0
end)

local heartache = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_heartache.xml", x, y)
EntityAddChild(player, heartache)

local times_executed = component_get_value2(entity_id, "LuaComponent", "mTimesExecuted", 0)
if times_executed >= 3 then
    edit_component(GameGetWorldStateEntity(), "WorldStateComponent", function(comp, vars)
        vars.damage_flash_multiplier = 1.0
    end)
    EntityKill(entity_id)
end