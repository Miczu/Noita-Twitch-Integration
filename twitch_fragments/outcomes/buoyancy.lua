--Buoyancy
--e?
--lame
--250
--todo
function twitch_buoyancy()
    local player_entity = get_player()
    if player_entity then
        local x,y = get_player_pos()
        shoot_projectile( player_entity, "data/entities/projectiles/deck/levitation_field.xml", x, y, 1, 1 )
    end
end
