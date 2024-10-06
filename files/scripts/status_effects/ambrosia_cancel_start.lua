
local entity_id    = GetUpdatedEntityID()
local player_id = EntityGetRootEntity(entity_id)
local children = EntityGetAllChildren(player_id)

local protections = {"FIRE","RADIOACTIVITY","EXPLOSION","MELEE","ELECTRICITY"}

--Disable Protective Perks

for z=1,#children do
    local v = children[z]
    if EntityHasTag(v,"effect_protection") then
        local comp = EntityGetFirstComponentIncludingDisabled(v,"GameEffectComponent")
        local status = ComponentGetValue2(comp,"effect")
        for k=1,#protections do
            if status == table.concat({"PROTECTION_",protections[k]}) then
                ComponentSetValue2( comp, "effect", "CUSTOM")
                ComponentSetValue2( comp, "custom_effect_id", table.concat({"PROTECTION_",protections[k]}))
                break
            end
        end
    end
end
