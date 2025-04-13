--Forced Checkpoint
--You meant to go back, right?
--bad_effects
--50
--
function twitch_conga_forced_checkpoint()
    local player = get_player()

    local x,y = EntityGetTransform(player)
    
    local points = {1500,3070,5110,6640,8700,10740}
    local new_y = -100

    --Cycle through various HM heights and reset the player to the closest one
    for z=1,#points do
        if points[z] < y then
            new_y = points[z]
        end
    end

    EntitySetTransform(player,195,new_y)

    --Give a very short duration of ambrosia while the camera's transfering to his new location
    local child = EntityLoad("data/entities/misc/effect_protection_all_short_evil.xml",195,new_y)
    EntityAddChild(player,child)
end

