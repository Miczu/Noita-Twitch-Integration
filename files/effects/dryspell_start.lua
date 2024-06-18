dofile_once("data/scripts/status_effects/status_list.lua")

local players = EntityGetWithTag("player_unit")

if #players > 0 then
    local player_id = players[1]

    -- remove all current stains
    for i,effect in ipairs(status_effects) do
        -- only status effects that are caused by stains are removed
        EntityRemoveStainStatusEffect(player_id, effect.id, 5)
    end

    -- disable stains
    local stains = EntityGetComponent(player_id, "SpriteStainsComponent")
    if stains ~= nil then
        EntitySetComponentIsEnabled(player_id, stains[1], false)
    end
end
