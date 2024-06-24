local players = EntityGetWithTag("player_unit")

if #players > 0 then
    local player_id = players[1]

    local stains = EntityGetComponentIncludingDisabled(player_id, "SpriteStainsComponent")
    if stains ~= nil then
        EntitySetComponentIsEnabled(player_id, stains[1], true)
    end
end
