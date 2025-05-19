--Shuffle Perks
--How are your reflexes?
--perks
--100
--todo
function twitch_shuffle_perks()
	local x, y = get_player_pos()
	local newDepth = math.max(tonumber(GlobalsGetValue("PerkShuffleDepth", y)), y) + 2500
	GlobalsSetValue("PerkShuffleDepth", newDepth)
	async(do_the_shuffle)
end

function do_the_shuffle()
	while true do
		local x, y = get_player_pos()
		
		local perks = EntityGetInRadiusWithTag(x, y, 200, "item_perk")
		if perks and #perks > 1 then
			local perkA = Random( 1, #perks )
			local perkB = perkA % #perks + 1
			
			local aId = perks[perkA]
			local bId = perks[perkB]
			
			local k, l = EntityGetTransform(aId)
			local n, m = EntityGetTransform(bId)
			EntitySetTransform(aId, n, m)
			EntitySetTransform(bId, k, l)
		end
		
		local endDepth = tonumber(GlobalsGetValue("PerkShuffleDepth", 0))
		if y > endDepth then
			break
		end
		wait(12)
	end
end

