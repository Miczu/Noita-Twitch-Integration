dofile("data/scripts/lib/utilities.lua")
local entity_id = GetUpdatedEntityID()
local player = EntityGetParent(entity_id)
local x, y = EntityGetTransform(entity_id)
local times_executed = component_get_value2(entity_id, "LuaComponent", "mTimesExecuted", 0)
local stacks = EntityGetAllChildren(player, "heart_attack_stack")
local var_comps = EntityGetComponent(entity_id, "VariableStorageComponent")
local max_max_hp_comp = var_comps[1]
local last_max_hp_comp = var_comps[2]
local last_heartbeat_comp = var_comps[3]

--nerf the heart trick (cap health boost per heart pickup to 2x usual value)
local damage_model_comp = EntityGetFirstComponent(player, "DamageModelComponent")
local max_hp = ComponentGetValue2(damage_model_comp, "max_hp")
local mLastMaxHpChangeFrame = ComponentGetValue2(damage_model_comp, "mLastMaxHpChangeFrame")
local max_max_hp = ComponentGetValue2(max_max_hp_comp, "value_float")
local last_max_hp = ComponentGetValue2(last_max_hp_comp, "value_float")
if mLastMaxHpChangeFrame == GameGetFrameNum() then
    local diff = max_hp - last_max_hp
    if diff > 0 then
        max_max_hp = max_max_hp + (diff * 2)
        ComponentSetValue2(max_max_hp_comp, "value_float", max_max_hp)
    end
end
if max_hp > max_max_hp then
    local max_hp_diff = max_max_hp / max_hp
    max_hp = max_max_hp
    ComponentSetValue2(damage_model_comp, "max_hp", max_hp)
end
ComponentSetValue2(last_max_hp_comp, "value_float", max_hp)

--heartbeat sound
local last_heartbeat = ComponentGetValue2(last_heartbeat_comp, "value_int")
local frames_since_last_heartbeat = times_executed - last_heartbeat
if (#stacks == 1 and frames_since_last_heartbeat > 120)
or (#stacks == 2 and frames_since_last_heartbeat > 90)
or (#stacks == 3 and frames_since_last_heartbeat > 60) then
    GamePlaySound("data/audio/Desktop/event_cues.bank", "event_cues/heartbeat/create", x, y)
    ComponentSetValue2(last_heartbeat_comp, "value_int", times_executed)
end

--intensify red screen vignette
if #stacks == 1 then
    edit_component(GameGetWorldStateEntity(), "WorldStateComponent", function(comp, vars) vars.damage_flash_multiplier = 1.0 end)
elseif #stacks == 2 then
    edit_component(GameGetWorldStateEntity(), "WorldStateComponent", function(comp, vars) vars.damage_flash_multiplier = 2.0 end)
elseif #stacks == 3 then
    edit_component(GameGetWorldStateEntity(), "WorldStateComponent", function(comp, vars) vars.damage_flash_multiplier = 4.0 end)
end

--apply another 15-second heartache effect
if times_executed == 1
or times_executed == 301 
or times_executed == 601 then
    local heart_attack_stack = EntityLoad("mods/Twitch-Integration/files/entities/misc/effect_heart_attack_stack.xml", x, y)
    EntityAddChild(player, heart_attack_stack)
end

--goodbye
if times_executed > 60 and #stacks == 0 then
    EntityKill(entity_id)
end
