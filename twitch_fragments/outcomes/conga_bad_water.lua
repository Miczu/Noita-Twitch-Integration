--Poisoned Water
--An abyssal hex afflicts you
--curses
--100
--
function twitch_conga_bad_water()
    local players = EntityGetWithTag("player_unit")
    for k=1,#players
    do v = players[k]
        local x,y = EntityGetTransform(v)
        local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_hex_water.xml",x,y)
        GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/megalaser/launch", x, y )
        EntityAddChild(v,c)
    end
end

