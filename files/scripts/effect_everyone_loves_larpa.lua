dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

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
  local exclude_projectiles = {
    --"data/entities/projectiles/bloomshot.xml",
  }

  for k=1,#projectiles do
    local projectile_id = projectiles[k]

    if ( EntityHasTag( projectile_id, "projectile_larpa_added" ) or
         EntityHasTag( projectile_id, "projectile_cloned" ) ) then
      goto nextprojectile
    end
    
    -- Reuse tag from "everyone loves larpa" mod for compatibility
    EntityAddTag( projectile_id, "projectile_larpa_added" )
    
    local projectile_filename = EntityGetFilename( projectile_id )
    if ( contains( exclude_projectiles, projectile_filename ) ) then
      goto nextprojectile
    end

    -- do not larpa projectiles that originate from the environment
    ---[[
    local projectilecomponents = EntityGetComponent( projectile_id, "ProjectileComponent" )
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
      lifetime = "300"
    } )
    --]]

    -- downwards larpa
    --[[
    EntityAddComponent( projectile_id, "LuaComponent", {
      script_source_file = "data/scripts/projectiles/larpa_downwards.lua",
      execute_every_n_frame = "5",
    } )
    EntityAddComponent( projectile_id, "LifetimeComponent", {
      lifetime = "300"
    } )
    --]]
    
    -- upwards larpa
    --[[
    EntityAddComponent( projectile_id, "LuaComponent", {
      script_source_file = "data/scripts/projectiles/larpa_upwards.lua",
      execute_every_n_frame = "5",
    } )
    EntityAddComponent( projectile_id, "LifetimeComponent", {
      lifetime = "300"
    } )
    --]]

    ::nextprojectile::
	end
end