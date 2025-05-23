--Random Projectile Effect
--What will your projectiles do?
--curses
--100
--Applies a random effect to your projectiles
function twitch_spiritusigneus_random_projectile_effect()

	local possible_outcomes = {}
	
	--get all enabled spiritusigneus-type projectile effects (all of them should contain the word "Shots")
	for _, outcome in ipairs(ti_outcomes) do
		if outcome.enabled and string.match(outcome.id,"spiritusigneus") and string.match(outcome.name,"Shots") then
			table.insert(possible_outcomes, outcome)
		end
	end
	
	if #possible_outcomes == 0 then
		GamePrintImportant("Nothing", "whoa")
		return
	end

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