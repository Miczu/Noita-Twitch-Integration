local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local kill_radius = 5
local status_clear_radius = 50

local snail_timeout = tonumber(GlobalsGetValue("SnailTimeout", "0"))
local snail_damagetimer = tonumber(GlobalsGetValue("SnailDamageTimer", "0"))

if snail_timeout > 0 then
	local snail_timeout_frame = tonumber(GlobalsGetValue("SnailTimeoutFrame", "0"))
	if GameGetFrameNum() > snail_timeout_frame then
		snail_timeout = snail_timeout - 1
		GlobalsSetValue("SnailTimeout", tostring(snail_timeout))
		GlobalsSetValue("SnailTimeoutFrame", tostring(GameGetFrameNum()))
	end
	return
end

local nearby_players = EntityGetInRadiusWithTag(x, y, kill_radius, "player_unit") or {}

if #nearby_players <= 0 then 
	nearby_players = EntityGetInRadiusWithTag(x, y, kill_radius, "polymorphed_player") or {} 
end

local clearable_players = EntityGetInRadiusWithTag(x, y, status_clear_radius, "player_unit") or {}

if #clearable_players <= 0 then 
	clearable_players = EntityGetInRadiusWithTag(x, y, status_clear_radius, "polymorphed_player") or {} 
end

for i, player in ipairs(clearable_players) do
	EntityRemoveStainStatusEffect(player, "PROTECTION_ALL", 1)
	local children = EntityGetAllChildren(player) or {}
	for _, child in ipairs(children) do
		local game_effect_comp = EntityGetFirstComponent(child, "GameEffectComponent")
		if game_effect_comp and ComponentGetValue2(game_effect_comp, "effect") == "PROTECTION_ALL" then
			EntityKill(child)
		end
	end
end

if snail_damagetimer < GameGetFrameNum() then
	for i, player in ipairs(nearby_players) do

		local hp = 4
		local hp_max = 4
		local percent_to_hurt = 0.33
		local damage_model_comp = EntityGetFirstComponentIncludingDisabled(player, "DamageModelComponent")
		if damage_model_comp then
			ComponentSetValue2(damage_model_comp, "wait_for_kill_flag_on_death", false)
			ComponentSetValue2(damage_model_comp, "invincibility_frames", 0)
			hp = ComponentGetValue2(damage_model_comp, "hp")
			hp_max = ComponentGetValue2(damage_model_comp, "max_hp" )
		end

		--Calculate how much damage to do in order to remove 1/3rd of the players HP
		--If the player is above 25 health and would've taken a fatal snail hit, they'll take just enough damage to be at 1 hp instead
		local damage_to_inflict = hp_max * percent_to_hurt
		if hp > 1 and hp <= damage_to_inflict then
			damage_to_inflict = hp - 0.04
		elseif hp <= damage_to_inflict then
			--This hit is practically guaranteed to be fatal
			GlobalsSetValue("SnailTimeout", tostring(120))

			--Gore visual effects for a fatal snail hit
			local px, py = EntityGetTransform(player)
			SetRandomSeed(px, py)
			local count = Random(3, 5)
			-- spawn guts
			for i = 1, count do
				EntityLoad("mods/twitch-integration/files/entities/particles/guts/guts" .. Random(1, 5) .. ".xml", px, py)
			end
		end

		--Inflict damage
		EntityInflictDamage(player, damage_to_inflict, "DAMAGE_CURSE", "immortal_snail", "BLOOD_EXPLOSION", 0, 0, entity_id)
		GamePlaySound( "data/audio/Desktop/animals.bank", "animals/slime/damage/physics_hit", x, y )

		--3 second cooldown between snail impacts
		GlobalsSetValue("SnailDamageTimer", tostring(GameGetFrameNum() + 180))
	end
end

