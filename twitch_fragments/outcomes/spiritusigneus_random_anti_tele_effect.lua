--Random Anti-Tele Effect
--Oh no, your teleports don't work properly!
--curses
--100
--Applies a random anti-teleportation effect
function twitch_spiritusigneus_random_anti_tele_effect()

	local possible_outcomes = {}
	
	--make a dictionary of enabled TI outcomes
	local tioutcomes = {}
	for _, outcome in ipairs(ti_outcomes) do
		if outcome.enabled then
			tioutcomes[outcome.id] = outcome
		end
	end

	table.insert(possible_outcomes, tioutcomes["conga_teleport_nullification"])
--	table.insert(possible_outcomes, tioutcomes["ceasefire"]);
--	table.insert(possible_outcomes, tioutcomes["conga_spells_to_worms"]);
	table.insert(possible_outcomes, tioutcomes["teleport_rideshare"]);
	table.insert(possible_outcomes, tioutcomes["teleport_beacon"]);
	table.insert(possible_outcomes, {id="spiritusigneus_tele_destabilise",name="Teleport Destabilisation",description="Your teleports are destabilised",fn=twitch_spiritusigneus_tele_destabilise})

	local index = math.random(1, #possible_outcomes)
	local outcome = possible_outcomes[index]
	if outcome ~= nil then
		local effect_name = outcome.name
		local effect_description = outcome.description
		GamePrintImportant(effect_name, effect_description)
		GamePrint("Random Anti-Tele Effect: " .. effect_name)
		outcome.fn()
	end
end


function twitch_spiritusigneus_tele_destabilise()
    async(effect_spiritusigneus_tele_destabilise)
end

function effect_spiritusigneus_tele_destabilise()
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

	local found = false
	local children = EntityGetAllChildren(player)
	for z=1,#children do
		if EntityGetName(children[z]) == "spiritusigneus_tele_destabilise" then
			local comp = EntityGetFirstComponentIncludingDisabled(children[z],"GameEffectComponent")
			ComponentSetValue2(comp,"frames",ComponentGetValue2(comp,"frames") + 3600)
			found=true
			break
		end
	end
	if found == false then
		local x,y = EntityGetTransform(player)
		local c = EntityLoad("mods/twitch-integration/files/entities/misc/effect_tele_destabilise.xml",x,y)
		EntityAddChild(player,c)
	end
end