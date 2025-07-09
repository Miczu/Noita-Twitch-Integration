dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
local projectiles = EntityGetWithTag("projectile")

larpa_exclude_projectiles = {
  "data/entities/projectiles/orbspawner.xml"                    , -- Spiraalikalma's (blue phantom) orb spawner shots (spawned orbs will still larpa)
  "data/entities/projectiles/orbspawner_green.xml"              , -- Kiukkukalma's (green phantom) orb spawner shots (spawned orbs will still larpa)
  "data/entities/animals/boss_alchemist/wand_orb.xml"           , -- Ylialkemisti's wand orbs (these normally spawn the wand beams)
  "data/entities/projectiles/enlightened_laser_dark_wand.xml"   , -- Ylialkemisti's dark wand beam (spawned projectiles will still larpa)
  "data/entities/projectiles/enlightened_laser_elec_wand.xml"   , -- Ylialkemisti's electric wand beam (spawned projectiles will still larpa)
  "data/entities/projectiles/enlightened_laser_light_wand.xml"  , -- Ylialkemisti's light wand beam (spawned projectiles will still larpa)
  "data/entities/projectiles/enlightened_laser_fire_wand.xml"   , -- Ylialkemisti's fire wand beam (spawned projectiles will still larpa)
  "data/entities/projectiles/slimetrail.xml"                    , -- Toukka's slime trail (spawned slimeblobs will still larpa)
  "data/entities/projectiles/thunderball_line.xml"              , -- Suur-Ukko's thunderball trail (spawned slow thunderballs will still larpa)
  "data/entities/projectiles/megalaser_blue.xml"                , -- Jättilaser-lennokki (toaster) megalaser (spawned lasers will still larpa)
  "data/entities/animals/boss_robot/rocket_roll.xml"            , -- Kolmisilmän silmä (mecha kolmi) rocket roll (spawned missiles will still larpa)
  "data/entities/animals/boss_wizard/statusburst.xml"           , -- Mestarien mestari (MoM) status burst (spawned status orbs will still larpa)
  "data/entities/animals/boss_centipede/firepillar.xml"         , -- Kolmisilmä fire pillar (spawned firepillar parts will still larpa)
  "data/entities/animals/boss_centipede/orb_homing.xml"         , -- Kolmisilmä orb homing (spawned orb homing parts will still larpa)
  "data/entities/animals/boss_centipede/melee.xml"              , -- Kolmisilmä melee shots (spawned orb circleshots will still larpa)
  "data/entities/projectiles/pollen_ball.xml"                   , -- Huhtasieni (giga fungus) pollen ball (spawned pollen will still larpa)
  "data/entities/animals/boss_alchemist/projectile_counter.xml" , -- Ylialkemisti's counter shield
  "data/entities/projectiles/darkflame_stationary.xml"          , -- Path of dark flame stationary trail
  "data/entities/projectiles/deck/glitter_bomb_shrapnel.xml"    , -- Glitter bomb shrapnel
  "data/entities/projectiles/deck/spiral_part.xml"              , -- Spiral shot parts
  "data/entities/projectiles/thunderburst_thundermage.xml"      , -- Thunderball lightning burst
}

local function contains(table,val)
  for i=1,#table do
    if table[i] == val then 
      return true
    end
  end
  return false
end

local larpa_enabled = GlobalsGetValue("twitch_everyone_loves_larpa_enabled")

if (#projectiles > 0 and #projectiles < 300) then -- disable larpa effects if there are excess projectiles
  for k=1,#projectiles do
    local projectile_id = projectiles[k]
    local tags = EntityGetTags(projectile_id)

    if (string.find(tags,"projectile_larpa_added") or string.find(tags,"projectile_cloned") or string.find(tags,"boss_alchemist") or string.find(tags,"ti_")) then
      goto nextprojectile
    end
    
    -- Reuse tag from "everyone loves larpa" mod for compatibility
    EntityAddTag(projectile_id,"projectile_larpa_added")
    
    local projectile_filename = EntityGetFilename(projectile_id)
    if (contains(larpa_exclude_projectiles,projectile_filename)) then
      goto nextprojectile
    end
    --[[
    if (string.find(larpa_enabled,"C")) then
      -- chaos larpa
      EntityAddComponent(projectile_id,"LuaComponent",{
        script_source_file = "data/scripts/projectiles/larpa_chaos.lua",
        execute_every_n_frame = "10",
      })
      EntityAddComponent(projectile_id,"LifetimeComponent",{
        lifetime = "300"
      })
    end
    --]]
    if (string.find(larpa_enabled,"O")) then
      -- orbit larpa
      EntityAddComponent(projectile_id,"VariableStorageComponent",{
          _tags = "orbit_projectile_type",
          name = "orbit_projectile_type",
          value_string = "orbit_larpa"
      })
      EntityAddComponent(projectile_id,"VariableStorageComponent",{
        _tags = "orbit_projectile_speed",
        name = "orbit_projectile_speed",
        value_float = "0"
      })
      EntityAddComponent(projectile_id,"LuaComponent",{
        script_source_file = "data/scripts/projectiles/orbit_projectile.lua",
        execute_every_n_frame = "1",
        remove_after_executed = "1"
      })
      EntityAddComponent(projectile_id,"LuaComponent",{
        script_source_file = "data/scripts/projectiles/orbit_projectile_rotation.lua",
        execute_every_n_frame = "1"
      })
    end
    
    if (string.find(larpa_enabled,"E")) then
      -- larpa explosion
      EntityAddComponent(projectile_id,"LuaComponent",{
        script_source_file = "data/scripts/projectiles/larpa_death.lua",
        execute_every_n_frame = "-1",
        execute_on_removed = "1"
      })
    end
    
    if (string.find(larpa_enabled,"B")) then
      -- larpa bounce
      EntityAddComponent(projectile_id,"LuaComponent",{
        script_source_file = "data/scripts/projectiles/bounce_larpa.lua",
        execute_every_n_frame = "1",
        remove_after_executed = "1"
      })
      local projectilecomponents = EntityGetComponent(projectile_id,"ProjectileComponent")
      for c=1,#projectilecomponents do
        ComponentSetValue2(projectilecomponents[c],"bounce_always",true)
        ComponentSetValue2(projectilecomponents[c],"bounces_left",1)
      end
    end
    --[[
    if (string.find(larpa_enabled,"T")) then
      -- copy trail
      EntityAddComponent(projectile_id,"LuaComponent",{
        script_source_file = "data/scripts/projectiles/larpa_chaos_2.lua",
        execute_every_n_frame = "5"
      })
      EntityAddComponent(projectile_id,"LifetimeComponent",{
        lifetime = "200"
      })
    end
    
    if (string.find(larpa_enabled,"D")) then
      -- downwards larpa
      EntityAddComponent(projectile_id,"LuaComponent",{
        script_source_file = "data/scripts/projectiles/larpa_downwards.lua",
        execute_every_n_frame = "10",
      })
      EntityAddComponent(projectile_id,"LifetimeComponent",{
        lifetime = "300"
      })
    end
    
    if (string.find(larpa_enabled,"U")) then
      -- upwards larpa
      EntityAddComponent(projectile_id,"LuaComponent",{
        script_source_file = "data/scripts/projectiles/larpa_upwards.lua",
        execute_every_n_frame = "10",
      })
      EntityAddComponent(projectile_id,"LifetimeComponent",{
        lifetime = "300"
      })
    end
    --]]
    ::nextprojectile::
	end
end