--Sugar Rush
--Enemies feel... different
--detrimental
--20
--
function twitch_sugarrush()
    local player = get_player()
    if (player) then
        local x, y = get_player_pos()
        local thingy = EntityLoad("mods/twitch-integration/files/effects/sugar_rush.xml", x, y)
        EntityAddChild(player, thingy)
    end
end
