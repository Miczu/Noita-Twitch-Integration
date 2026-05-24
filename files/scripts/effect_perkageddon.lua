dofile_once( "data/scripts/perks/perk_list.lua" )

local perk_to_give = GlobalsGetValue("TI_perkageddon","EXTRA_KNOCKBACK")
local plyr_x,plyr_y = EntityGetTransform(GetUpdatedEntityID())

function AddEnemyPerkIcon(entity_id, x, y, perk)
	local perk_icon = EntityLoad("data/entities/misc/perks/enemy_icon.xml", x, y)
	local sprite = EntityGetFirstComponent(perk_icon, "SpriteComponent")

	if sprite ~= nil then
		ComponentSetValue2(sprite, "image_file", perk.ui_icon)
		EntityAddChild(entity_id, perk_icon)
	end
end

function GivePerkToEnemy(entity_id, x, y, perk_data)
	AddEnemyPerkIcon(entity_id, x, y, perk_data)

	if perk_data.id == "PROJECTILE_HOMING" then
		--Use a severely nerfed homing instead of vanilla's homing, since vanilla's perk homing on enemies has perfect near-unavoidable tracking and would essentially turn into "kill the streamer" without any of the exciting flair glass cannon has
		EntityAddComponent2(
			entity_id,
			"LuaComponent",
			{
				script_shot="mods/Twitch-Integration/files/scripts/status_effects/homing_shoot_enemy.lua",
				execute_every_n_frame=-1
			}
		)
		return
	elseif perk_data.id == "EXTRA_HP" then
		--buffs the extra hp perk to give 2.5x hp instead of just 1.5x hp so it has a more meaningful impact on gameplay. I think 5x hp would be fair if this wasn't in the context of being TI
		local dmgcomp = EntityGetFirstComponentIncludingDisabled(entity_id,"DamageModelComponent") or 0
		if dmgcomp > 0 then
			local hp = ComponentGetValue2(dmgcomp,"max_hp")
			ComponentSetValue2(dmgcomp,"max_hp",hp * 2.5)
			ComponentSetValue2(dmgcomp,"hp",hp * 2.5)
		end
	end

	if not perk_data.usable_by_enemies then
		return
	end

  local function run_effect(effect)
    if effect == nil then
      return
    end

    local effect_comp, effect_entity = GetGameEffectLoadTo(entity_id, effect, true)
    if effect_comp ~= nil then
      ComponentSetValue2(effect_comp, "frames", -1)
    end
    
    if not perk_data.do_not_remove then
      if effect_comp ~= nil then
        ComponentAddTag(effect_comp, "perk_component")
      end

      EntityAddTag(effect_entity, "perk_entity")
    end
  end

	run_effect(perk_data.game_effect)
	run_effect(perk_data.game_effect2)

	if perk_data.particle_effect ~= nil then
		local particle_id = EntityLoad("data/entities/particles/perks/" .. perk_data.particle_effect .. ".xml")
		if not perk_data.do_not_remove then
			EntityAddTag(particle_id, "perk_entity")
		end

		EntityAddChild(entity_id, particle_id)
	end

	if perk_data.func_enemy ~= nil then
		perk_data.func_enemy(0, entity_id, nil, 1)
	elseif perk_data.func ~= nil then
		perk_data.func(0, entity_id, nil, 1)
	end
end

local perk_data = perk_list[1]
for k=1,#perk_list do
    if perk_list[k].id == perk_to_give then
        perk_data = perk_list[k]
        break 
    end
end

local targets = EntityGetInRadiusWithTag(plyr_x, plyr_y, 256, "enemy")
for k=1,#targets do
    if EntityHasTag(targets[k], "ti_perkageddoned") == false then
        GivePerkToEnemy(targets[k], plyr_x, plyr_y, perk_data, 0)
        EntityAddTag(targets[k],"ti_perkageddoned")
    end
end