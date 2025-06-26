--Nerf Potions
--Your potions are a little bit worse now
--detrimental
--60
--
function twitch_spiritusigneus_nerf_potions()
	-- "nerfing" transformation definitions
	local nerf = {}
	nerf["magic_liquid_teleportation"] = "magic_liquid_unstable_teleportation"   --tele to unstable tele
	nerf["magic_liquid_unstable_teleportation"] = "magic_liquid_chaotic_teleportation"  --unstable tele to useless tele
	nerf["magic_liquid_protection_all"] = "magic_liquid_protection_half"  --ambrosia to weak ambrosia
	nerf["magic_liquid_protection_half"] = "magic_liquid_protection_none" --weak ambrosia to scambrosia
	nerf["water"] = "water_thicc"  --water to thick water
	nerf["water_swamp"] = "water_thicc"  --swamp water to thick water
	nerf["swamp"] = "swamp_thicc"  --swamp to thick swamp
	nerf["water_salt"] = "water_thicc" --brine to thick water
	nerf["water_ice"] = "water_thicc"  --chilly water to thick water
	nerf["acid"] = "juice_lime" --acid to lime juice
	nerf["magic_liquid_faster_levitation_and_movement"] = "magic_liquid_faster_levitation" --hastium to levitatium
	nerf["magic_liquid_movement_faster"] = "magic_liquid_faster_levitation" --acceleratium to levitatium
	nerf["magic_liquid_hp_regeneration"] = "magic_liquid_weakness" --healthium to diminution
	nerf["magic_liquid_hp_regeneration_unstable"] = "magic_liquid_weakness" --lively concoction to diminution
	nerf["magic_liquid_invisibility"] = "blood_cold" --invisiblium to freezing liquid
	nerf["blood_worm"] = "urine" --worm blood to urine
	nerf["blood"] = "slime" --blood to slime
	nerf["beer"] = "molut" --beer to molut
	nerf["milk"] = "molut" --milk to molut
	nerf["midas"] = "gold_molten" --draught of midas to molten gold
	
	local inventory = GetInven()
	local items = EntityGetAllChildren(inventory)
	if items ~= nil then
		for _, item_id in ipairs(items) do
			if EntityHasTag(item_id, "potion") then
				local material_inv_comp = EntityGetFirstComponentIncludingDisabled(item_id, "MaterialInventoryComponent")
				local mats = ComponentGetValue2(material_inv_comp, "count_per_material_type")
				local mat_amounts = {}
				for k, mat in ipairs(mats) do
					local i = k - 1
					if mat > 0 then
						local mat_id = CellFactory_GetName(i)
						local amount = mat
						if nerf[mat_id] ~= nil then
							if mat_amounts[nerf[mat_id]] == nil then
								mat_amounts[nerf[mat_id]] = amount
							else
								mat_amounts[nerf[mat_id]] = mat_amounts[nerf[mat_id]] + amount
							end
						else
							if mat_amounts[mat_id] == nil then
								mat_amounts[mat_id] = amount
							else
								mat_amounts[mat_id] = mat_amounts[mat_id] + amount
							end
						end
					end
				end
				RemoveMaterialInventoryMaterial(item_id)
				for mat_id, mat_amount in pairs(mat_amounts) do
					AddMaterialInventoryMaterial(item_id, mat_id, mat_amount)
				end
			end
		end
	end
end