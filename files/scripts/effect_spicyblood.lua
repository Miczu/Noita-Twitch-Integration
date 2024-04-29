
local player_id = GetUpdatedEntityID()
local plyr_x, plyr_y = EntityGetTransform(player_id)

local targets = EntityGetInRadiusWithTag(plyr_x, plyr_y, 256, "enemy")
for k=1,#targets
do local v = targets[k]
    local comp = EntityGetFirstComponentIncludingDisabled(v,"DamageModelComponent")
    if comp then
        local blood_mult = ComponentGetValue2(comp,"blood_multiplier") or 1
        local blood_mat = GlobalsGetValue("ti_spicyblood_type","acid")
    
        ComponentSetValue2(comp,"blood_material",blood_mat)
        EntitySetDamageFromMaterial( v, blood_mat, 0)
        if blood_mult < 3 then
            ComponentSetValue2(comp,"blood_multiplier",3)
        end
    end
end
