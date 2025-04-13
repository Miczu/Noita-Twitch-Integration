local entity_id = GetUpdatedEntityID()
entity_id = EntityGetRootEntity(entity_id)

local comp = EntityGetFirstComponentIncludingDisabled(entity_id,"DamageModelComponent")
if comp ~= 0 then

    local materials = {
        "water",
        "mud",
        "water_swamp",
        "water_salt",
        "swamp",
        "snow",
        "water_ice",
        "water_fading",
    }

    for k=1,#materials do
        EntitySetDamageFromMaterial( entity_id, materials[k], 0.00055)
    end

end