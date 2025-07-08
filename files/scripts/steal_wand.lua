dofile("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local victim = EntityGetRootEntity( entity_id )
local pos_x, pos_y = EntityGetTransform(victim)
local inventory = EntityGetFirstComponentIncludingDisabled(victim, "Inventory2Component")
if inventory ~= nil then
    local active_item = ComponentGetValue2(inventory, "mActualActiveItem")
    if active_item ~= nil and active_item ~= 0 then
        -- if EntityHasTag(active_item, "wand") or EntityHasTag(active_item, "item_pickup") or EntityHasTag(active_item, "tablet") then  -- Keeping this if statement here in case we wanna revert anything
            ComponentSetValue2(inventory, "mForceRefresh", true)
            EntityRemoveFromParent(active_item)
            EntitySetComponentsWithTagEnabled(active_item,"enabled_in_hand",false)
            EntitySetComponentsWithTagEnabled(active_item,"enabled_in_world",true) -- spawn item/wand
            -- EntityKill(active_item)
            ComponentSetValue2(inventory, "mActualActiveItem", 0)
            ComponentSetValue2(inventory, "mActiveItem", 0)

            if EntityHasTag(active_item, "wand") then -- spawn wand ghost
                EntityLoad("mods/Twitch-integration/files/entities/animals/wand_ghost.xml", pos_x, pos_y)
            end
            EntitySetTransform(active_item, pos_x, pos_y)
            if not EntityHasTag(active_item, "wand") then -- throw item
                local velcomp_victim = EntityGetFirstComponentIncludingDisabled(victim, "VelocityComponent")
                local bodycomp = EntityGetFirstComponentIncludingDisabled(active_item, "PhysicsBodyComponent")
                if velcomp_victim ~= nil and bodycomp ~= nil then
                    local vel_x, vel_y = ComponentGetValue2(velcomp_victim, "mVelocity")
                    local mPixelCount = ComponentGetValue2(bodycomp, "mPixelCount")
                    PhysicsApplyForce(active_item, vel_x*2*mPixelCount, (vel_y*mPixelCount)-(5*mPixelCount))
                    PhysicsApplyTorque(active_item, mPixelCount/10+vel_x*(mPixelCount/5))
                end
                -- TODO: Fix the code breaking the kick function of items

                -- activate thrown item functionality
                for _,comp in ipairs(EntityGetComponentIncludingDisabled(active_item, "LuaComponent") or {}) do
                    local script_throw = ComponentGetValue2(comp, "script_throw_item")
                    if script_throw and script_throw ~= "" then
                        print("manually throwing!")
                        local GetUpdatedEntityID_old = GetUpdatedEntityID
                        GetUpdatedEntityID = function() return active_item end
                        dofile_once(script_throw)
                        throw_item(pos_x, pos_y, pos_x, pos_y-50)
                        GetUpdatedEntityID = GetUpdatedEntityID_old
                        break
                    end
                end
            end
            --EntityAddChild(wand, active_item)
        -- end
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