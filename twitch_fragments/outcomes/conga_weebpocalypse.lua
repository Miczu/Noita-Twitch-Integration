--Weebpocalypse
--The end times are here! Weebs have taken over!
--curses
--10
--Spawns an apocalypse of hentacle related hazards
function twitch_conga_weebpocalypse()
    local players = EntityGetWithTag("player_unit")
    for k=1,#players
    do v = players[k]
        local x,y = EntityGetTransform(v)
        local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_weebpocalypse.xml",x,y)
        EntityAddChild(v,c)
    end
    local x,y = EntityGetTransform(EntityGetWithTag("player_unit")[1])
    EntityLoad("mods/Twitch-integration/files/entities/particles/image_emitters/magical_symbol_materia_fungus.xml",x,y)
    GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/greed_curse/create", x,y )
end

