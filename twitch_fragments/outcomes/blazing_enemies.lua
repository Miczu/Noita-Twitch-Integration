--Blazing Enemies
--Everyone took a lesson from stendari
--curses
--119
--Every enemy is set on fire, becomes immune to fire and tries to set you on fire
function twitch_blazing_enemies()
    local players = EntityGetWithTag("player_unit")
    for k=1,#players
    do v = players[k]
        local x,y = EntityGetTransform(v)
        local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_blazing_enemies.xml",x,y)
        EntityAddChild(v,c)
    end
    --EntityLoad("mods/Twitch-integration/files/entities/particles/image_emitters/magical_symbol_materia_fungus.xml",x,y)
    --GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/greed_curse/create", x,y )
end

