--Perkageddon
--Don't act like you're the only person who can use them
--curses
--90
--
function twitch_conga_perkageddon()
    async(effect_conga_perkageddon)
end

function RandomFromTableWeighted(t,seed1,seed2)
    if seed1 == nil then seed1 = 666 end
    if seed2 == nil then seed2 = 999 end
    SetRandomSeed(seed1+seed2,seed1-seed2-seed2)
    local total_weight = 0
    local p_t = {}
    for k=1,#t do
        if t[k].requirement == nil or t[k].requirement() ~= false then
            table.insert(p_t,t[k])
        end
    end
    for _, entry in ipairs(p_t) do
        total_weight = total_weight + entry.weight
    end

    local rnd = Randomf(0, total_weight)
    for _, entry in ipairs(p_t) do
        if rnd <= entry.weight then
            return entry
        else rnd = rnd - entry.weight end
    end
    return p_t[#p_t] --Randomf has a miniscule chance to overflow
end

function effect_conga_perkageddon()
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

    local found = false
    local children = EntityGetAllChildren(player)
    for z=1,#children do
        if EntityGetName(children[z]) == "ti_event_perkageddon" then
            local comp = EntityGetFirstComponentIncludingDisabled(children[z],"GameEffectComponent")
            ComponentSetValue2(comp,"frames",ComponentGetValue2(comp,"frames") + 5400)
            found = true
            break
        end
    end
    if found == false then
        local x,y = EntityGetTransform(player)
        local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_perkageddon.xml",x,y)
        EntityAddChild(player,c)
    end

    --Conga: I think more fun & interactive perks should be prioritised, ones which would make chat type KEKW when they see it happen
    --More borings perks, even if they're effective, should probably be lower down on the list since even if they're powerful outcomes since it'd be really boring if there was nothing for you to see & laugh at
    local perkOptions = 
    {
        {
            id = "MOVEMENT_FASTER",
            weight = 0.5,
            requirement = function()
                if ModIsEnabled("Apotheosis") then return false end --You can set any condition you want here but in this case I use it to remove the perk from the pool if Apotheosis is enabled, since those perks don't exist in apoth. Could use this to make harder perks appear if Dunk is closer to winning?
                return true
            end
        },
        {
            id = "SAVING_GRACE",
            weight = 0.5,
        },
        {
            id = "INVISIBILITY",
            weight = 1.0,
        },
        {
            id = "EXTRA_HP",
            weight = 0.5,
        },
        {
            id = "GLASS_CANNON",
            weight = 0.02, --Conga: I don't think glass cannon is fun as a viewer, it's just going to be the streamer dying suddenly from something happening off-screen without any warning or heads up... But it might be fun once in a blue moon
        },
        {
            id = "LOW_HP_DAMAGE_BOOST",
            weight = 0.5,
        },
        -- {
        --     id = "RESPAWN",
        --     weight = 1.0, -- Doesn't work
        -- },
        {
            id = "PROTECTION_FIRE",
            weight = 0.25,
        },
        -- {
        --     id = "PROTECTION_RADIOACTIVITY",
        --     weight = 0.1, --Who cares about toxic immunity?
        -- },
        {
            id = "PROTECTION_EXPLOSION",
            weight = 0.5,
        },
        {
            id = "TELEPORTITIS",
            weight = 1.0,
        },
        {
            id = "STAINLESS_ARMOUR",
            weight = 1.0,
        },
        {
            id = "PROJECTILE_HOMING",
            weight = 1.0,
        },
        {
            id = "FREEZE_FIELD",
            weight = 1.0,
        },
        -- {
        --     id = "BLEED_SLIME",
        --     weight = 0.25,
        -- },
        -- {
        --     id = "BLEED_OIL",
        --     weight = 0.25,
        -- },
        -- {
        --     id = "BLEED_GAS",
        --     weight = 0.25,
        -- },
        {
            id = "SHIELD",
            weight = 1.0,
        },
        {
            id = "REVENGE_EXPLOSION",
            weight = 1.0,
        },
        {
            id = "REVENGE_TENTACLE",
            weight = 1.0,
        },
        {
            id = "REVENGE_BULLET",
            weight = 1.0,
        },
        {
            id = "PROJECTILE_REPULSION",
            weight = 1.0,
            requirement = function()
                if ModIsEnabled("Apotheosis") then return false end --You can set any condition you want here but in this case I use it to remove the perk from the pool if Apotheosis is enabled, since those perks don't exist in apoth. Could use this to make harder perks appear if Dunk is closer to winning?
                return true
            end
        },
        {
            id = "ORBIT",
            weight = 0.5,
        },
        -- {
        --     id = "ANGRY_GHOST",
        --     weight = 1.0, --Doesn't work
        -- },
        {
            id = "HUNGRY_GHOST",
            weight = 0.25,
        },
        {
            id = "ELECTRICITY",
            weight = 0.25, --Alternate universe ionized
        },
        {
            id = "EXTRA_KNOCKBACK",
            weight = 1.0,
        },
        {
            id = "LOWER_SPREAD",
            weight = 0.5,
        },
        {
            id = "BOUNCE",
            weight = 1.0,
        },
        -- {
        --     id = "FAST_PROJECTILES",
        --     weight = 0.5, --90% sure this doesn't even work
        -- },
        {
            id = "DUPLICATE_PROJECTILE",
            weight = 1.0,
        },
        {
            id = "CONTACT_DAMAGE",
            weight = 1.0,
        },
    }

    local x,y = EntityGetTransform(get_player_event())
    local chosen_perk = RandomFromTableWeighted(perkOptions,x+y,y-x)
    GlobalsSetValue("TI_perkageddon",chosen_perk.id)
end

