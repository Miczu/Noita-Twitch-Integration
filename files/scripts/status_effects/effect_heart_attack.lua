dofile("data/scripts/lib/utilities.lua")
local entity_id = GetUpdatedEntityID()
local player = EntityGetParent(entity_id)
local x, y = EntityGetTransform(entity_id)

local times_executed = component_get_value2(entity_id, "LuaComponent", "mTimesExecuted", 0)
local last_heartbeat = component_get_value2(entity_id, "VariableStorageComponent", "value_int", 0)
local frames_since_last_heartbeat = times_executed - last_heartbeat

--heartbeat sound
if ((times_executed < 301 or times_executed >= 1201) and frames_since_last_heartbeat > 120)
or (((times_executed >= 301 and times_executed < 601) or (times_executed >= 901 and times_executed < 1201)) and frames_since_last_heartbeat > 90)
or ((times_executed >= 601 and times_executed < 901) and frames_since_last_heartbeat > 60) then
    print("heartbeat")
    GamePlaySound("data/audio/Desktop/event_cues.bank", "event_cues/heartbeat/create", x, y)
    edit_component(entity_id, "VariableStorageComponent", function(comp, vars) vars.value_int = times_executed end)
end

--intensify red screen vignette
if times_executed == 1 
or times_executed == 1201 then
    edit_component(GameGetWorldStateEntity(), "WorldStateComponent", function(comp, vars) vars.damage_flash_multiplier = 1.0 end)
elseif times_executed == 301 
or times_executed == 901 then
    edit_component(GameGetWorldStateEntity(), "WorldStateComponent", function(comp, vars) vars.damage_flash_multiplier = 2.0 end)
elseif times_executed == 601 then
    edit_component(GameGetWorldStateEntity(), "WorldStateComponent", function(comp, vars) vars.damage_flash_multiplier = 4.0 end)
end

--apply another 15-second heartache effect
if times_executed == 1
or times_executed == 301 
or times_executed == 601 then
    local heartache = EntityLoad("mods/Twitch-Integration/files/entities/misc/effect_heartache.xml", x, y)
    EntityAddChild(player, heartache)
end

--goodbye
if times_executed == 1501 then
    EntityKill(entity_id)
end
