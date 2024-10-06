local entity_id = GetUpdatedEntityID()
entity_id = EntityGetRootEntity(entity_id)

local effectTest = GameGetGameEffectCount( entity_id, "WET" )
if effectTest >= 1 then
     EntityInflictDamage( entity_id, 0.04, "DAMAGE_CURSE", "Abyssal Hex", "NONE", 0, 0, 0 )
end