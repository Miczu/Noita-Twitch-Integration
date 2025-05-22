--Possess Wand
--Chat needs this for a bit
--bad_effects
--200
--
function twitch_conga_steal_wand()
    local players = EntityGetWithTag("player_unit")
    for k=1,#players
    do v = players[k]
        local x,y = EntityGetTransform(player)
        local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_steal_wand.xml",x,y)
        EntityAddChild(v,c)
        GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/blindness/create",x,y)
    end
end

