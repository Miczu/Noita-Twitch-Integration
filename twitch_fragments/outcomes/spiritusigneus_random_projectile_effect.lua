--Random Projectile Effect
--What will your projectiles do?
--curses
--100
--Applies a random effect to your projectiles
function twitch_spiritusigneus_random_projectile_effect()

	local possible_outcomes = {}
	
	--make a dictionary of enabled TI outcomes
	local tioutcomes = {}
	for _, outcome in ipairs(ti_outcomes) do
		if outcome.enabled then
			tioutcomes[outcome.id] = outcome
		end
	end

	table.insert(possible_outcomes, {id="spiritusigneus_anti_homing_shot",name="Anti-Homing Shots",description="Your projectiles will avoid enemies",fn=twitch_spiritusigneus_anti_homing_shot})
	table.insert(possible_outcomes, tioutcomes["ceasefire"])
	table.insert(possible_outcomes, tioutcomes["everyone_loves_larpa"])
	table.insert(possible_outcomes, tioutcomes["spiritusigneus_line_arc_shot"])
	table.insert(possible_outcomes, tioutcomes["moneyshot"])
	table.insert(possible_outcomes, tioutcomes["conga_spells_to_worms"])
	table.insert(possible_outcomes, tioutcomes["conga_teleport_nullification"])

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