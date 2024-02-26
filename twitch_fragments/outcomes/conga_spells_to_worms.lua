--Spells 2 Worms
--I hope you like gardening
--curses
--100
--
function twitch_conga_spells_to_worms()
    local players = EntityGetWithTag("player_unit")
    for k=1,#players
    do v = players[k]
        local x,y = EntityGetTransform(v)
        local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_spells_to_worms.xml",x,y)
        EntityAddChild(v,c)
    end
end

