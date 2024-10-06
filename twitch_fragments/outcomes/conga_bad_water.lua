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
        local found = false
        local children = EntityGetAllChildren(v)
        for z=1,#children do
            if EntityGetName(children[z]) == "apotheosis_hex_water" then
                local comp = EntityGetFirstComponentIncludingDisabled(children[z],"GameEffectComponent")
                ComponentSetValue2(comp,"frames",ComponentGetValue2(comp,"frames") + 2700)
                found = true
                break
            end
        end
        if found == false then
            local x,y = EntityGetTransform(v)
            local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_hex_water.xml",x,y)
            EntityAddChild(v,c)
        end
        GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/megalaser/launch", x, y )
    end
end
