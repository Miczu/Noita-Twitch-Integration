--Silent but Deadly
--Don't breathe it in
--enemies
--50
--Spawns the Varjokupla
function twitch_silent_but_deadly()
    async(effect_spawn_fart_enemy)

end

function effect_spawn_fart_enemy()
    local player

    repeat
        wait(1);
        player = get_player_nopoly();
    until player > 0;
    
    spawn_fart_enemy(15)
    
    wait(10*60);
    local x, y = get_player_pos()
    local lurker = EntityGetInRadiusWithTag( x, y, 600, "fart_enemy" ) or {}

    if #lurker == 0 then
        spawn_fart_enemy(10)
        wait(5*60);
        
        x, y = get_player_pos()
        lurker = EntityGetInRadiusWithTag( x, y, 600, "fart_enemy" ) or {}
        if #lurker == 0 then
            spawn_fart_enemy(5)
        end
    end
end

function spawn_fart_enemy(range)
    spawn_entity_in_view_random_angle("data/entities/animals/lurker.xml", range, range, range, function(entity_id)
        EntityAddTag(entity_id, "fart_enemy")
        end)
end