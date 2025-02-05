--Heart Attack
--Heartache x3
--curses
--150
--Stacks a 15-second heartache modifier on the player every 5 seconds, 3 times in a row
function heart_attack()
    local player = EntityGetWithTag("player_unit")[1]
    if player then
        local x, y = EntityGetTransform(player)
        local heart_attack = EntityLoad("mods/twitch-integration/files/entities/misc/effect_heart_attack.xml", x, y)
        EntityAddChild(player, heart_attack)
    end
end