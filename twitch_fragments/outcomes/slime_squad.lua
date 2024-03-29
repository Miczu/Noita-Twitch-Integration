--Slime Squad
--A truly toxic ambush
--enemies
--150
--Spawns a squad of 4 to 17 enemies consisting of toxic slimes, acid slimes, and mother slimes. Affected by current player health
function twitch_slime_squad()
    local additional = 0
    local damage_model = EntityGetFirstComponentIncludingDisabled(get_player(), "DamageModelComponent")
    if damage_model ~= nil then
       local hp = tonumber(ComponentGetValue2(damage_model, "hp"))
       if hp > 150 then additional = additional + 1 end
       if hp > 200 then additional = additional + 1 end
       if hp > 250 then additional = additional + 1 end
    end
    local toxic_slime_count = Random(2 + additional, 4 + additional)
    local acid_slime_count = Random(1 + additional, 2 + additional)
    local mother_slime_count = Random(1 + additional, 2 + additional)
    local near_min = 60 + (additional * 10)
    local near_max = 90 + (additional * 10)
    local far_min = 150 + (additional * 10)
    local far_max = 190 + (additional * 10)
    for i = 1, toxic_slime_count do
        local entity = "data/entities/animals/slimeshooter_weak.xml"
        if Random(1, 100) > 50 + (additional * 12) then entity = "data/entities/animals/slimeshooter.xml" end
        spawn_something(entity, Random(near_min, near_max), Random(far_min, far_max), false, false, append_viewer_name)
    end
    for i = 1, acid_slime_count do
        local entity = "data/entities/animals/acidshooter_weak.xml"
        if Random(1, 100) > 50 + (additional * 12) then entity = "data/entities/animals/acidshooter.xml" end
        spawn_something(entity, Random(near_min, near_max), Random(far_min, far_max), false, false, append_viewer_name)
    end
    for i = 1, mother_slime_count do
        local entity = "data/entities/animals/giantshooter_weak.xml"
        if Random(1, 100) > 50 + (additional * 12) then entity = "data/entities/animals/giantshooter.xml" end
        spawn_something(entity, Random(near_min, near_max), Random(far_min, far_max), false, false, append_viewer_name)
    end
end