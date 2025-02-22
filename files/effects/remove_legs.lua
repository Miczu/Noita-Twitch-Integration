local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
local player = EntityGetParent(entity_id)
local childs = EntityGetAllChildren(player)
local walker_count = 0
local attacker_count = 0
local badge_count = 0
for _, child in ipairs(childs) do
    if badge_count < 1 then
        local badge = EntityGetFirstComponent(child, "UIIconComponent")
        if badge ~= nil then
            local icon = ComponentGetValue2(badge, "name")
            if icon == "$perk_attack_foot" then
                EntityKill(child)
                badge_count = badge_count + 1
            end
        end
    end
    if attacker_count < 1 then
        local attacker = EntityGetFirstComponent(child,
                                                 "IKLimbAttackerComponent")
        if attacker ~= nil then
            EntityKill(child)
            attacker_count = attacker_count + 1
        end
    end

    if walker_count < 4 then
        local walker = EntityGetFirstComponent(child, "IKLimbWalkerComponent")
        if walker ~= nil then
            EntityKill(child)
            walker_count = walker_count + 1
        end
    end
end

local platformingcomponent = EntityGetFirstComponentIncludingDisabled(player,"CharacterPlatformingComponent")
if (platformingcomponents ~= nil) then
    local run_speed = tonumber(ComponentGetMetaCustom(platformingcomponent,"run_velocity")) * 0.8
    local vel_x = math.abs(tonumber(ComponentGetMetaCustom(platformingcomponent,"velocity_max_x"))) * 0.8

    local vel_x_min = 0 - vel_x
    local vel_x_max = vel_x

    ComponentSetMetaCustom(platformingcomponent, "run_velocity", run_speed)
    ComponentSetMetaCustom(platformingcomponent, "velocity_min_x", vel_x_min)
    ComponentSetMetaCustom(platformingcomponent, "velocity_max_x", vel_x_max)
end

local children = EntityGetAllChildren(player)
for z=1,#children do
    local ccomp = EntityGetFirstComponentIncludingDisabled(children[z],"LuaComponent")
    if ComponentGetValue2(ccomp,"script_source_file","data/scripts/perks/attack_foot_climb.lua") then
        EntityKill(children[z]) --This should remove 1 lukki leg script for 1 spiderman vote; meaning it *shouldn't* break lukki legs if given/taken as a perk.
        break
    end
end
