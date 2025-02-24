
local ti_actions_to_edit = {

    ["TELEPORT_PROJECTILE"] = {
		action 		= function()
            if reflecting then
                add_projectile("data/entities/projectiles/deck/teleport_projectile.xml")
                c.fire_rate_wait = c.fire_rate_wait + 3
                c.spread_degrees = c.spread_degrees - 2.0
            else
                if EntityGetName( GetUpdatedEntityID() ) == "$animal_wand_ghost" then
                    --Inverted behavior
                    add_projectile("mods/Twitch-Integration/files/entities/projectiles/deck/teleport_projectile.xml")
                    c.fire_rate_wait = c.fire_rate_wait + 3
                    c.spread_degrees = c.spread_degrees - 2.0
                else
                    --Normal behavior
                    add_projectile("data/entities/projectiles/deck/teleport_projectile.xml")
                    c.fire_rate_wait = c.fire_rate_wait + 3
                    c.spread_degrees = c.spread_degrees - 2.0
                end
            end
		end,
    },

    ["TELEPORT_PROJECTILE_SHORT"] = {
		action 		= function()
            if reflecting then
                add_projectile("data/entities/projectiles/deck/teleport_projectile_short.xml")
                c.spread_degrees = c.spread_degrees - 2.0
            else
                if EntityGetName( GetUpdatedEntityID() ) == "$animal_wand_ghost" then
                    add_projectile("mods/Twitch-Integration/files/entities/projectiles/deck/teleport_projectile_short.xml")
                    c.spread_degrees = c.spread_degrees - 2.0
                else
                    add_projectile("data/entities/projectiles/deck/teleport_projectile_short.xml")
                    c.spread_degrees = c.spread_degrees - 2.0
                end
            end
		end,
    },

}

--Script should scan through each item, and if rebalances are enabled, it'll do all of them; otherwise only do mandatory additions
--Not currently enabled, but would just need to be uncommented in theory.
for i=1,#actions do -- fast as fuck boi
    if ti_actions_to_edit[actions[i].id] then
        for key, value in pairs(ti_actions_to_edit[actions[i].id]) do
            actions[i][key] = value
        end
    end
end
