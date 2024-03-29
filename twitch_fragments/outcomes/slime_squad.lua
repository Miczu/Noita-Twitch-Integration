--Slime Squad
--A truly toxic ambush
--enemies
--150
--Spawns a squad of 4 to 17 enemies consisting of toxic slimes, acid slimes, and mother slimes. Affected by current player health.
function twitch_slime_squad()
    local additional = 0
    local player = get_player()
    if player == nil then
        spawn_entity_in_view_random_angle("data/entities/animals/giantshooter_weak.xml", Random(30, 70), Random(70, 130), 20, append_viewer_name)
        spawn_entity_in_view_random_angle("data/entities/animals/giantshooter_weak.xml", Random(30, 70), Random(70, 130), 20, append_viewer_name)
        return
    end
    local damage_model = EntityGetFirstComponentIncludingDisabled(player, "DamageModelComponent")
    if damage_model ~= nil then
       local hp = tonumber(ComponentGetValue2(damage_model, "hp"))
       if hp > 150 then additional = additional + 1 end
       if hp > 200 then additional = additional + 1 end
       if hp > 250 then additional = additional + 1 end
    end
    local toxic_slime_count = Random(2 + additional, 4 + additional)
    local acid_slime_count = Random(1 + additional, 2 + additional)
    local mother_slime_count = Random(1 + additional, 2 + additional)
    local near_min = 40 + (additional * 10)
    local near_max = 70 + (additional * 10)
    local far_min = 130 + (additional * 10)
    local far_max = 170 + (additional * 10)
    for i = 1, toxic_slime_count do
        local entity = "data/entities/animals/slimeshooter_weak.xml"
        if Random(1, 100) > 50 + (additional * 12) then entity = "data/entities/animals/slimeshooter.xml" end
        spawn_entity_in_view_random_angle(entity, Random(near_min, near_max), Random(far_min, far_max), 20, append_viewer_name)
    end
    for i = 1, acid_slime_count do
        local entity = "data/entities/animals/acidshooter_weak.xml"
        if Random(1, 100) > 50 + (additional * 12) then entity = "data/entities/animals/acidshooter.xml" end
        spawn_entity_in_view_random_angle(entity, Random(near_min, near_max), Random(far_min, far_max), 20, append_viewer_name)
    end
    for i = 1, mother_slime_count do
        local entity = "data/entities/animals/giantshooter_weak.xml"
        if Random(1, 100) > 50 + (additional * 12) then entity = "data/entities/animals/giantshooter.xml" end
        spawn_entity_in_view_random_angle(entity, Random(near_min, near_max), Random(far_min, far_max), 20, append_viewer_name)
    end
end