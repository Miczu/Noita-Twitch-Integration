--Homing Blackhole
--It seems you have a new follower
--bad_effects
--80
--
function twitch_conga_blackhole_boomerang()
    local players = EntityGetWithTag("player_unit")
    for k=1,#players
    do v = players[k]
        local x, y = EntityGetTransform(v)
        SetRandomSeed( x + y, x + y + 857 )
                    
        local angle = Random( 0, 31415 ) * 0.0001
        local length = 250
        
        local ex = x + math.cos( angle ) * length
        local ey = y - math.sin( angle ) * length

        local blackhole_id = EntityLoad( "mods/Twitch-integration/files/entities/animals/blackhole_boomerang.xml", ex, ey )
        local comp = EntityGetFirstComponent(blackhole_id,"GhostComponent")
        ComponentSetValue2(comp,"mEntityHome",v)
        
    end
end

