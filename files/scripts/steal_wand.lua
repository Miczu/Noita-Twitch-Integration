dofile("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local victim = EntityGetRootEntity( entity_id )
local pos_x, pos_y = EntityGetTransform(victim)
local inventory = EntityGetFirstComponentIncludingDisabled(victim, "Inventory2Component")
if inventory ~= nil then
    local active_wand = ComponentGetValue2(inventory, "mActualActiveItem")
    if active_wand ~= nil then
        if EntityHasTag(active_wand, "wand") or EntityHasTag(active_wand, "potion") then
            EntityRemoveFromParent(active_wand)
            EntitySetComponentsWithTagEnabled(active_wand,"enabled_in_hand",false)
            EntitySetComponentsWithTagEnabled(active_wand,"enabled_in_world",true)
            --EntityKill(active_wand)
            ComponentSetValue2(inventory, "mActualActiveItem", 0)
            ComponentSetValue2(inventory, "mActiveItem", 0)

            if EntityHasTag(active_wand, "wand") then
                EntityLoad("mods/Twitch-integration/files/entities/animals/wand_ghost.xml", pos_x, pos_y)
            end
            EntitySetTransform(active_wand, pos_x, pos_y)
            if EntityHasTag(active_wand, "potion") then
                local velcomp_victim = EntityGetFirstComponentIncludingDisabled(victim, "VelocityComponent")
                if velcomp_victim ~= nil then
                    local vel_x, vel_y = ComponentGetValue2(velcomp_victim, "mVelocity")
                    PhysicsApplyForce(active_wand, vel_x*50, vel_y*25-125)
                end
            end
            --EntityAddChild(wand, active_wand)
        end
    end
end


--GamePrint("Victim ID is " .. tostring(victim))
--GamePrint("Entity ID is " .. tostring(entity_id))

EntityKill(entity_id)

--Look buddy, this code here's held together with lighter fluid and gunpowder, no smoking.
--Take away utilities.lua and it magically breaks
--Try to force the wand into the wand ghost's hand and it magically breaks
--Anything else and it magically breaks
--You can try to improve it if you dare, but know no salvation will be waiting for you when the fireworks start cracking