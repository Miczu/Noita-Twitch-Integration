--The Alchemic Circle
--Yikes
--unknown
--20
--Spawns a circle of random liquids
function twitch_random_circle()
    local above = false
    local rand = Random(0, 1)
    if rand > 0 then
        above = true
    end
    local mats = {               -- random selection of 25 materials (19 dangerous / 4 very good / 2 very deadly)
        "void_liquid",
        "lava",
        "liquid_fire",
        "poison",
        "acid",
        "slime",
        "gold_molten",
        "metal_molten",
        "radioactive_liquid",                   -- toxic sludge
        "material_darkness",                    -- ominous liquid
        "material_confusion",                   -- flummoxium
        "blood_cold",                           -- freezing liquid
        "cursed_liquid",                        -- greed curse liquid
        "mimic_liquid",                         -- mimicium
        "magic_liquid_polymorph",               -- polymorphine
        "magic_liquid_random_polymorph",        -- chaotic polymorphine
        "magic_liquid_berserk",                 -- berserkium
        "magic_liquid_weakness",                -- diminution
        "magic_liquid_unstable_teleportation",  -- unstable teleportatium
        "magic_liquid_faster_levitation_and_movement",   -- hastium
        "magic_liquid_protection_all",                   -- ambrosia
        "magic_liquid_hp_regeneration",                  -- healthium
        "midas",                                         -- draught of midas
        --"creepy_liquid",                                 -- creepy liquid
        "just_death"                                     -- instant deathium
    };

    spawn_something("data/entities/projectiles/deck/circle_acid.xml", 80, 160, above, true, function(circle)
        async(function()
            ComponentSetValue( EntityGetFirstComponent( circle, "LifetimeComponent" ), "lifetime", "900" )
            ComponentSetValue( EntityGetFirstComponent( circle, "ParticleEmitterComponent" ), "airflow_force", "0.01" );
            ComponentSetValue( EntityGetFirstComponent( circle, "ParticleEmitterComponent" ), "image_animation_speed", "3" );
            for i = 1, 10 do
                ComponentSetValue( EntityGetFirstComponent( circle, "ParticleEmitterComponent" ), "emitted_material_name", mats[ Random( 1, #mats ) ] );
                wait(15)
            end
        end)
    end)
end
