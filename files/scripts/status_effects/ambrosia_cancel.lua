
local entity_id    = GetUpdatedEntityID()
local player_id = EntityGetRootEntity(entity_id)

local ambrosia_test = GameGetGameEffectCount( player_id, "PROTECTION_ALL" )

--Disable Ambrosia
if ambrosia_test ~= 0 then
    local comp = GameGetGameEffect( player_id, "PROTECTION_ALL" )
    if comp ~= 0 then
        ComponentSetValue2( comp, "effect", "NONE")
    end
end
