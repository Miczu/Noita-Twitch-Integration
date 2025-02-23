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
if (platformingcomponent ~= nil) then
    local run_speed = tonumber(ComponentGetMetaCustom(platformingcomponent,"run_velocity")) * 0.8
    local vel_x = math.abs(tonumber(ComponentGetMetaCustom(platformingcomponent,"velocity_max_x"))) * 0.8

    local vel_x_min = 0 - vel_x
    local vel_x_max = vel_x

    ComponentSetMetaCustom(platformingcomponent, "run_velocity", run_speed)
    ComponentSetMetaCustom(platformingcomponent, "velocity_min_x", vel_x_min)
    ComponentSetMetaCustom(platformingcomponent, "velocity_max_x", vel_x_max)
    local gravity = 350 * (0.75^math.max(0,tonumber(GlobalsGetValue( "PERK_PICKED_GAS_BLOOD_PICKUP_COUNT","0"))))
    ComponentSetValue2( platformingcomponent, "pixel_gravity", gravity )
end



--Reset lukki legs taken count to allow future legs to function properly and remove the associated script if no additional lukki legs are taken.
local lukki_leg_count = tonumber(GlobalsGetValue( "PERK_PICKED_ATTACK_FOOT_PICKUP_COUNT","1"))
lukki_leg_count = math.max(0,lukki_leg_count - 1)
GlobalsGetValue( "PERK_PICKED_ATTACK_FOOT_PICKUP_COUNT",tostring(lukki_leg_count))
if lukki_leg_count == 0 then
    GameRemoveFlagRun( "ATTACK_FOOT_CLIMBER" )
    local children = EntityGetAllChildren(player,"perk_entity")
    for z=1,#children do
        local ccomp = EntityGetFirstComponentIncludingDisabled(children[z],"LuaComponent")
        if ccomp ~= 0 and ComponentGetValue2(ccomp,"script_source_file","data/scripts/perks/attack_foot_climb.lua") then --This prints errors regardless of many times you politely ask noita to confirm the component exists but doesn't stop the code from working.
            EntityKill(children[z])
            break
        end
    end
end

--Lukki legs is bad on an in-game level and an in-code level. I want the hours of my life back
--To any poor souls who need to work on this code in the future, I wish you the best of luck, you'll need it
--https://congalyne.neocities.org/images/conga_tired2.png