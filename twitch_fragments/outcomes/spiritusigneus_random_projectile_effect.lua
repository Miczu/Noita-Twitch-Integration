--Random Projectile Effect
--What will your projectiles do?
--curses
--100
--Applies a random effect to your projectiles
function twitch_spiritusigneus_random_projectile_effect()

	--make a dictionary of enabled TI outcomes
	local tioutcomes = {}
	for _, outcome in ipairs(ti_outcomes) do
		if outcome.enabled then
			tioutcomes[outcome.id] = outcome
		end
	end

	local possible_outcomes = {
		{
			id = "spiritusigneus_anti_homing_shot",
			name = "Anti-Homing Shots",
			description = "Your projectiles will avoid enemies",
			fn = twitch_spiritusigneus_anti_homing_shot,
		},
		{
			id = "necauqua_crooked_shots",
			name = "Crooked Shots",
			description = "Your projectiles fire at a random offset angle",
			fn = twitch_necauqua_crooked_shots,
		},
		tioutcomes["ceasefire"],
		tioutcomes["everyone_loves_larpa"],
		tioutcomes["spiritusigneus_line_arc_shot"],
		tioutcomes["moneyshot"],
		tioutcomes["conga_spells_to_worms"],
		tioutcomes["conga_teleport_nullification"],
	}

	local index = math.random(1, #possible_outcomes)
	local outcome = possible_outcomes[index]
	if outcome ~= nil then
		local effect_name = outcome.name
		local effect_description = outcome.description
		GamePrintImportant(effect_name, effect_description)
		GamePrint("Random Projectile Effect: " .. effect_name)
		outcome.fn()
	end
end

function twitch_spiritusigneus_anti_homing_shot()
    async(effect_spiritusigneus_anti_homing_shot)
end

function effect_spiritusigneus_anti_homing_shot()
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

	local found = false
	local children = EntityGetAllChildren(player)
	for z=1,#children do
		if EntityGetName(children[z]) == "spiritusigneus_anti_homing" then
			local comp = EntityGetFirstComponentIncludingDisabled(children[z],"GameEffectComponent")
			ComponentSetValue2(comp,"frames",ComponentGetValue2(comp,"frames") + 2100)
			found=true
			break
		end
	end
	if found == false then
		local x,y = EntityGetTransform(player)
		local c = EntityLoad("mods/twitch-integration/files/entities/misc/effect_anti_homing_shot.xml",x,y)
		EntityAddChild(player,c)
	end
end

function twitch_necauqua_crooked_shots()
    async(effect_necauqua_crooked_shots)
end

---@param effect entity_id
local function set_random_angle(effect)
    local too_straight = 15
    local angle = math.random(360 - too_straight * 2) + too_straight
    ComponentSetValue2(EntityGetFirstComponent(effect, "VariableStorageComponent"), "value_int", angle)
end

---@async
function effect_necauqua_crooked_shots()
    local player = nil
    while not player do
        wait(1);
        player = EntityGetWithTag("player_unit")[1]
    end

    for _, child in pairs(EntityGetAllChildren(player) or {}) do
        if EntityGetName(child) == "necauqua_crooked_shots" then
            set_random_angle(child)
            local comp = EntityGetFirstComponentIncludingDisabled(child, "GameEffectComponent")
            ComponentSetValue2(comp, "frames", ComponentGetValue2(comp, "frames") + 2700)
            return
        end
    end

    local x, y = EntityGetTransform(player)
    local effect = EntityLoad("mods/twitch-integration/files/entities/misc/effect_crooked_shots.xml", x, y)
    set_random_angle(effect)

    EntityAddChild(player, effect)
end
