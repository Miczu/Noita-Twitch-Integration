--Buoyancy
--e?
--lame
--250
--todo
function twitch_buoyancy()
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

    if player then
        local x,y = get_player_pos()
        shoot_projectile( player, "data/entities/projectiles/deck/levitation_field.xml", x, y, 1, 1 )
    end
end
