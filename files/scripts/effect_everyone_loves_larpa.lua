dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local larpa_exclude_projectiles = {
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
  "data/entities/projectiles/darkflame_stationary.xml"          , -- Path of dark flame stationary trail
  "data/entities/projectiles/deck/glitter_bomb_shrapnel.xml"    , -- Glitter bomb shrapnel
  "data/entities/projectiles/deck/spiral_part.xml"              , -- Spiral shot parts
  "data/entities/projectiles/thunderburst_thundermage.xml"      , -- Thunderball lightning burst
}

local projectiles = EntityGetWithTag( "projectile" )

local function contains(table, val)
  for i=1,#table do
    if table[i] == val then 
      return true
    end
  end
  return false
end

if ( #projectiles > 0 ) then

  for k=1,#projectiles do
    local projectile_id = projectiles[k]

    if ( EntityHasTag( projectile_id, "projectile_larpa_added" ) or
         EntityHasTag( projectile_id, "projectile_cloned" ) ) then
      goto nextprojectile
    end
    
    -- Reuse tag from "everyone loves larpa" mod for compatibility
    EntityAddTag( projectile_id, "projectile_larpa_added" )
    
    local projectile_filename = EntityGetFilename( projectile_id )
    if ( contains( larpa_exclude_projectiles, projectile_filename ) ) then
      goto nextprojectile
    end

    local projectilecomponents = EntityGetComponent( projectile_id, "ProjectileComponent" )

    -- do not larpa projectiles that originate from the environment
    --[[
    local mWhoShot = ComponentGetValue2(projectilecomponents[1], "mWhoShot" )
    
    if ( mWhoShot == 0 ) then
      goto nextprojectile
    end
    --]]
    
    -- do not larpa projectiles that have no initial velocity
    --[[
    local velocitycomponents = EntityGetComponent( projectile_id, "VelocityComponent" )
    
    if ( velocitycomponents == nil ) then
      goto nextprojectile
    end
    
    local mVelx,mVely = ComponentGetValueVector2( velocitycomponents[1], "mVelocity" )
    
    if ( ( mVelx == 0 ) and ( mVely == 0 ) ) then
      goto nextprojectile
    end
    --]]
    
    -- chaos larpa
    ---[[
    EntityAddComponent( projectile_id, "LuaComponent", {
      script_source_file = "data/scripts/projectiles/larpa_chaos.lua",
      execute_every_n_frame = "10",
    } )
    EntityAddComponent( projectile_id, "LifetimeComponent", {
      lifetime = "300"
    } )
    --]]

    -- orbit larpa
    ---[[
    EntityAddComponent( projectile_id, "VariableStorageComponent", {
        _tags = "orbit_projectile_type",
        name = "orbit_projectile_type",
        value_string = "orbit_larpa"
    } )
    EntityAddComponent( projectile_id, "VariableStorageComponent", {
      _tags = "orbit_projectile_speed",
      name = "orbit_projectile_speed",
      value_float = "0"
    } )
    EntityAddComponent( projectile_id, "LuaComponent", {
      script_source_file = "data/scripts/projectiles/orbit_projectile.lua",
      execute_every_n_frame = "1",
      remove_after_executed = "1"
    } )
    EntityAddComponent( projectile_id, "LuaComponent", {
      script_source_file = "data/scripts/projectiles/orbit_projectile_rotation.lua",
      execute_every_n_frame = "1"
    } )
    --]]

    -- larpa explosion
    ---[[
    EntityAddComponent( projectile_id, "LuaComponent", {
      script_source_file = "data/scripts/projectiles/larpa_death.lua",
      execute_every_n_frame = "-1",
      execute_on_removed = "1"
    } )
    --]]

    -- larpa bounce
    ---[[
    EntityAddComponent( projectile_id, "LuaComponent", {
      script_source_file = "data/scripts/projectiles/bounce_larpa.lua",
      execute_every_n_frame = "1",
      remove_after_executed = "1"
    } )
    for c=1,#projectilecomponents do
      ComponentSetValue2( projectilecomponents[c], "bounce_always", true )
      ComponentSetValue2( projectilecomponents[c], "bounces_left", 1 )
    end
    --]]

    -- copy trail
    --[[
    EntityAddComponent( projectile_id, "LuaComponent", {
      script_source_file = "data/scripts/projectiles/larpa_chaos_2.lua",
      execute_every_n_frame = "5",
    } )
    EntityAddComponent( projectile_id, "LifetimeComponent", {
      lifetime = "200"
    } )
    --]]

    -- downwards larpa
    --[[
    EntityAddComponent( projectile_id, "LuaComponent", {
      script_source_file = "data/scripts/projectiles/larpa_downwards.lua",
      execute_every_n_frame = "10",
    } )
    EntityAddComponent( projectile_id, "LifetimeComponent", {
      lifetime = "300"
    } )
    --]]
    
    -- upwards larpa
    --[[
    EntityAddComponent( projectile_id, "LuaComponent", {
      script_source_file = "data/scripts/projectiles/larpa_upwards.lua",
      execute_every_n_frame = "10",
    } )
    EntityAddComponent( projectile_id, "LifetimeComponent", {
      lifetime = "300"
    } )
    --]]

    ::nextprojectile::
	end
end