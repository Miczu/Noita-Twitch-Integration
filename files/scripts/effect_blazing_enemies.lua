
local player_id = GetUpdatedEntityID()
local plyr_x, plyr_y = EntityGetTransform(player_id)

local targets = EntityGetInRadiusWithTag(plyr_x, plyr_y, 256, "enemy")
for k=1,#targets
do local v = targets[k]
    if EntityHasTag(v, "ti_blazing") == false then
       
        local c = EntityLoad("mods/Twitch-Integration/files/entities/misc/effect_blazing_enemies_victim.xml",plyr_x,plyr_y)
        EntityAddChild(v,c)

        local comp = EntityGetFirstComponentIncludingDisabled(v,"DamageModelComponent")
        ComponentSetValue2(comp,"fire_probability_of_ignition",0)

        EntityAddTag(v,"ti_blazing")

        EntityLoad("data/entities/particles/polymorph_explosion.xml",x,y)
    end
end