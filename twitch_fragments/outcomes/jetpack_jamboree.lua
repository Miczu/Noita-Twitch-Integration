--Jetpack Jamboree
--Everyone gets a jetpack!
--curses
--150
--todo
function twitch_jetpack_jamboree()
    local x, y = get_player_pos()
    for _, entity in pairs(EntityGetInRadiusWithTag(x, y, 1024, "enemy") or {}) do
        local animal_ai = EntityGetFirstComponent(entity, "AnimalAIComponent") or {};
        if animal_ai ~= nil then
            ComponentSetValue(animal_ai, "can_fly", "1");
        end

        local path_finding = EntityGetFirstComponent(entity,"PathFindingComponent");
        if path_finding ~= nil then
            ComponentSetValue(path_finding, "can_fly", "1");
        end

        local jetpack_particles = EntityAddComponent(entity,"ParticleEmitterComponent",
        {
            _tags = "jetpack",
            emitted_material_name = "rocket_particles",
            x_pos_offset_min = "-1",
            x_pos_offset_max = "1",
            y_pos_offset_min = "",
            y_pos_offset_max = "0",
            x_vel_min = "-7",
            x_vel_max = "7",
            y_vel_min = "80",
            y_vel_max = "180",
            count_min = "3",
            count_max = "7",
            lifetime_min = "0.1",
            lifetime_max = "0.2",
            create_real_particles = "0",
            emit_cosmetic_particles = "1",
            emission_interval_min_frames = "0",
            emission_interval_max_frames = "1",
            is_emitting = "1"
        });
    end
end
