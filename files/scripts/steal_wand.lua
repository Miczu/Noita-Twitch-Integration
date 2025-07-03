dofile("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local victim = EntityGetRootEntity( entity_id )
local pos_x, pos_y = EntityGetTransform(victim)
local inventory = EntityGetFirstComponentIncludingDisabled(victim, "Inventory2Component")
if inventory ~= nil then
    local active_item = ComponentGetValue2(inventory, "mActualActiveItem")
    if active_item ~= nil then
        if EntityHasTag(active_item, "wand") or EntityHasTag(active_item, "potion") then
        -- if EntityHasTag(active_item, "wand") or EntityHasTag(active_item, "item_pickup") then
            EntityRemoveFromParent(active_item)
            EntitySetComponentsWithTagEnabled(active_item,"enabled_in_hand",false)
            EntitySetComponentsWithTagEnabled(active_item,"enabled_in_world",true)
            --EntityKill(active_wand)
            ComponentSetValue2(inventory, "mActualActiveItem", 0)
            ComponentSetValue2(inventory, "mActiveItem", 0)

            if EntityHasTag(active_item, "wand") then -- spawn wand ghost
                EntityLoad("mods/Twitch-integration/files/entities/animals/wand_ghost.xml", pos_x, pos_y)
            end
            EntitySetTransform(active_item, pos_x, pos_y) -- spawn item/wand
            if EntityHasTag(active_item, "potion") then -- throw item
            -- if EntityHasTag(active_item, "item_pickup") then -- throw item
                local velcomp_victim = EntityGetFirstComponentIncludingDisabled(victim, "VelocityComponent")
                if velcomp_victim ~= nil then
                    local vel_x, vel_y = ComponentGetValue2(velcomp_victim, "mVelocity")
                    PhysicsApplyForce(active_item, vel_x*50, vel_y*25-125)
                    PhysicsApplyTorque(active_item, 0.5+vel_x*5)
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