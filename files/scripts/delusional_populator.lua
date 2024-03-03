
local entity_id    = GetUpdatedEntityID()
local parent_id = EntityGetParent(entity_id)
if EntityHasTag(parent_id, "player_unit") then
	
    --wizard_returner is not on the list, keeps causing burning for some reason
    local illusion_list = { "bat", "firebug", "frog_big", "roboguard", "shaman", "shotgunner", "skullfly", "skullrat", "sniper", "wizard_poly", "zombie" }

    local pos_x, pos_y = EntityGetTransform( entity_id )
    SetRandomSeed( GameGetFrameNum(), pos_x + entity_id )
    local pos_x = pos_x + Random(200,-200)
    local pos_y = pos_y + Random(200,-200)

    local rnd = Random( 1, #illusion_list )
    local target = illusion_list[rnd]

    math.randomseed(pos_x + pos_y)
    if math.random(1,1500) == 1 then
        -- :)
        EntityLoad( table.concat({"data/entities/animals/",target,".xml"}), pos_x, pos_y ) 
    else
        EntityLoad( table.concat({"mods/Twitch-integration/files/entities/animals/psychotic/",target,".xml"}), pos_x, pos_y )
    end
else
    EntityKill(entity_id)
end