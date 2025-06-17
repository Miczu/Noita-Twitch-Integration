local entity_id = GetUpdatedEntityID()
local player_id = EntityGetRootEntity(entity_id)

local teledestabilised = false

--Check if player is still teleport destabilised
local children = EntityGetAllChildren(player_id)
if children then
    for k=1,#children
    do local v = children[k]
        if EntityGetName(v) == "spiritusigneus_tele_destabilise" and v ~= entity_id then
            teledestabilised = true
        end
    end
end

--If the player is no longer destabilised, restabilise teleportitis
if teledestabilised == false then
    local pos_x, pos_y = EntityGetTransform(player_id)
    local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_teleport_restabilise.xml", pos_x, pos_y)
    EntityAddChild(player_id,c)
end

--Remove child as it's no longer needed
EntityKill(entity_id)