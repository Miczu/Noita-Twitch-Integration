local players = EntityGetWithTag("player_unit")

if #players > 0 then
    local player_id = players[1]

    local stains = EntityGetComponentIncludingDisabled(player_id, "SpriteStainsComponent")
    if stains ~= nil then
        EntitySetComponentIsEnabled(player_id, stains[1], true)
    end

    -- restore fire damage
    local damage_model = EntityGetComponent(player_id, "DamageModelComponent")
    if damage_model ~= nil then
        local fire = ComponentObjectGetValue2(damage_model[1], "damage_multipliers", "fire")
        ComponentObjectSetValue2(damage_model[1], "damage_multipliers", "fire", fire * 2)
    end
end
