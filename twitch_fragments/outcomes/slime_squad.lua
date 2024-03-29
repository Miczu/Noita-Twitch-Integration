--Slime Squad
--A truly toxic ambush
--enemies
--150
--Spawns a squad of 4 to 17 enemies consisting of toxic slimes, acid slimes, and mother slimes. Affected by player max HP.
function twitch_slime_squad()
    local additional = 0
    local damage_model = EntityGetFirstComponentIncludingDisabled(get_player(), "DamageModelComponent")
    if damage_model ~= nil then
       local max_hp = tonumber(ComponentGetValue2(damage_model, "max_hp"))
       if max_hp > 150 then additional = additional + 1 end
       if max_hp > 200 then additional = additional + 1 end
       if max_hp > 250 then additional = additional + 1 end
    end
    local toxic_slime_count = Random(2 + additional, 4 + additional)
    local acid_slime_count = Random(1 + additional, 2 + additional)
    local mother_slime_count = Random(1 + additional, 2 + additional)
    for i = 1, toxic_slime_count do
        local entity = "data/entities/animals/slimeshooter_weak.xml"
        if Random(1, 100) > 50 + (additional * 12) then entity = "data/entities/animals/slimeshooter.xml" end
        spawn_something(entity, Random(60, 90), Random(150, 190), false, false, append_viewer_name)
    end
    for i = 1, acid_slime_count do
        local entity = "data/entities/animals/acidshooter_weak.xml"
        if Random(1, 100) > 50 + (additional * 12) then entity = "data/entities/animals/acidshooter.xml" end
        spawn_something(entity, Random(60, 90), Random(150, 190), false, false, append_viewer_name)
    end
    for i = 1, mother_slime_count do
        local entity = "data/entities/animals/giantshooter_weak.xml"
        if Random(1, 100) > 50 + (additional * 12) then entity = "data/entities/animals/giantshooter.xml" end
        spawn_something(entity, Random(60, 90), Random(150, 190), false, false, append_viewer_name)
    end
end