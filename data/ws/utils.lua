dofile_once("data/scripts/lib/utilities.lua")
twitch_viewers = {}
function hello()
    GamePrintImportant("Hello", "Hello")
    GamePrint("Hello")
    print("Hello")
end

function get_player() return EntityGetWithTag("player_unit")[1] end

function get_player_pos()
    local x, y = EntityGetTransform(get_player())
    if x == nil then
        return GameGetCameraPos()
    else
        return x, y
    end
end

function get_closest_entity(px, py, tag)
    if not py then
        tag = px
        px, py = get_player_pos()
    end
    return EntityGetClosestWithTag(px, py, tag)
end

function get_entity_mouse(tag)
    local mx, my = DEBUG_GetMouseWorld()
    return get_closest_entity(mx, my, tag or "hittable")
end

function teleport(x, y) EntitySetTransform(get_player(), x, y) end

function spawn_entity(ename, offset_x, offset_y)
    local x, y = get_player_pos()
    x = x + (offset_x or 0)
    y = y + (offset_y or 0)
    return EntityLoad(ename, x, y)
end

function print_component_info(c)
    local members = ComponentGetMembers(c)
    if not members then return end
    local frags = {}
    for k, v in pairs(members) do
        table.insert(frags, k .. ': ' .. tostring(v))
    end
    print(table.concat(frags, '\n'))
end

function print_detailed_component_info(c)
    local members = ComponentGetMembers(c)
    if not members then return end
    local frags = {}
    for k, v in pairs(members) do
        if (not v) or #v == 0 then
            local mems = ComponentObjectGetMembers(10, k)
            if mems then
                table.insert(frags, k .. ">")
                for k2, v2 in pairs(mems) do
                    table.insert(frags, "  " .. k2 .. ": " .. tostring(v2))
                end
            else
                v = "?"
            end
        end
        table.insert(frags, k .. ': ' .. tostring(v))
    end
    print(table.concat(frags, '\n'))

end

function print_entity_info(e)
    local comps = EntityGetAllComponents(e)
    if not comps then
        print("Invalid entity?")
        return
    end
    for idx, comp in ipairs(comps) do
        print(comp, "-----------------")
        print_component_info(comp)
    end
end

function list_funcs(filter)
    local ff = {}
    for k, v in pairs(getfenv()) do
        local first_letter = k:sub(1, 1)
        if first_letter:upper() == first_letter then
            if (not filter) or k:lower():find(filter:lower()) then
                table.insert(ff, k)
            end
        end
    end
    table.sort(ff)
    print(table.concat(ff, "\n"))
end

function get_child_info(e)
    local children = EntityGetAllChildren(e)
    for _, child in ipairs(children) do
        print(child, EntityGetName(child) or "[no name]")
    end
end

function do_here(fn)
    local f = loadfile(fn)
    if type(f) ~= "function" then
        print("Loading error; check logger.txt for details.")
    end
    setfenv(f, getfenv())
    f()
end

function insert_constant(outcome)
    table.insert(outcome_generators, function() return outcome end)
end

function get_players()
    return EntityGetWithTag( "player_unit" ) or {};
end

function resolve_localized_name(s, default)
    if s:sub(1, 1) ~= "$" then return s end
    local rep = GameTextGet(s)
    if rep and rep ~= "" then
        return rep
    else
        return default or s
    end
end

function twiddle_health(f)
    local damagemodels =
        EntityGetComponent(get_player(), "DamageModelComponent")
    if (damagemodels ~= nil) then
        for i, damagemodel in ipairs(damagemodels) do
            local max_hp = tonumber(ComponentGetValue(damagemodel, "max_hp"))
            local cur_hp = tonumber(ComponentGetValue(damagemodel, "hp"))
            local new_cur, new_max = f(cur_hp, max_hp)
            ComponentSetValue(damagemodel, "max_hp", new_max)
            ComponentSetValue(damagemodel, "hp", new_cur)
        end
    end
end

function urand(mag) return math.floor((math.random() * 2.0 - 1.0) * mag) end

function spawn_item(path, offset_mag)
    local x, y = get_player_pos()
    local dx, dy = urand(offset_mag or 0), urand(offset_mag or 0)
    print(x + dx, y + dy)
    local entity = EntityLoad(path, x + dx, y + dy)
end

function wrap_spawn(path, offset_mag)
    return function() spawn_item(path, offset_mag) end
end

-- 0 to not limit axis, -1 to limit to negative values, 1 to limit to positive values
function generate_value_in_range(max_range, min_range, limit_axis)
    local range = (max_range or 0) - (min_range or 0)
    if (limit_axis or 0) == 0 then limit_axis = Random(0, 1) == 0 and 1 or -1 end

    return (Random(0, range) + (min_range or 0)) * limit_axis
end

function move_something(entity_id, min_dist, max_dist, from_above, black_hole, callback)
    async(function()
        local x, y = get_player_pos()
        y = y + 110
        local dx = generate_value_in_range(max_dist, min_dist, 0)
        local dummy = EntityLoad("data/entities/dummy_hax.xml", x + dx, y)
        wait(20)
        local dummy_x, dummy_y = EntityGetTransform(dummy)

        EntityKill(dummy)
        if from_above then
            local rhit, rx, ry = Raytrace(dummy_x, dummy_y - 30, dummy_x,
                                          dummy_y - 190)
            if rhit then
                dummy_y = ry + 20
            else
                dummy_y = dummy_y - 170
            end
        end
        if black_hole then
            EntityLoad("data/entities/projectiles/deck/black_hole.xml", dummy_x,
                       dummy_y)
        end
        EntitySetTransform(entity_id, dummy_x, dummy_y)
        if callback then callback(entity_id); end
    end)
end

function spawn_something(entity_path, min_dist, max_dist, from_above, black_hole, callback)
    async(function()
        local x, y = get_player_pos()
        y = y + 110
        local dx = generate_value_in_range(max_dist, min_dist, 0)
        local dummy = EntityLoad("data/entities/dummy_hax.xml", x + dx, y)
        wait(20)
        local dummy_x, dummy_y = EntityGetTransform(dummy)

        EntityKill(dummy)
        if from_above then
            local rhit, rx, ry = Raytrace(dummy_x, dummy_y - 30, dummy_x,
                                          dummy_y - 190)
            if rhit then
                dummy_y = ry + 20
            else
                dummy_y = dummy_y - 170
            end
        end
        if black_hole then
            EntityLoad("data/entities/projectiles/deck/black_hole.xml", dummy_x,
                       dummy_y)
        end
        local eid = EntityLoad(entity_path, dummy_x, dummy_y)
        if callback then callback(eid); end
    end)
end

function spawn_item_in_range(path, min_x_range, max_x_range, min_y_range,
                             max_y_range, limit_x_axis, limit_y_axis,
                             spawn_blackhole)
    local x, y = get_player_pos()
    local dx = generate_value_in_range(max_x_range, min_x_range, limit_x_axis)
    local dy = generate_value_in_range(max_y_range, min_y_range, limit_y_axis)

    if spawn_blackhole then
        EntityLoad("data/entities/projectiles/deck/black_hole.xml", x + dx,
                   y + dy)
    end
    local ix, iy = FindFreePositionForBody(x + dx, y + dy, 300, 300, 30)
    return EntityLoad(path, ix, iy)
end

function spawn_item(path, min_range, max_range, spawn_blackhole)
    return spawn_item_in_range(path, min_range, max_range, min_range, max_range,
                               0, 0, spawn_blackhole)
end

function GetInven()
    local childs = EntityGetAllChildren(get_player())
    local inven = nil
    if childs ~= nil then
        for _, child in ipairs(childs) do
            if EntityGetName(child) == "inventory_quick" then
                inven = child
            end
        end
    end
    return inven
end

function GetWands()
    local childs = EntityGetAllChildren(get_player())
    local inven = nil
    if childs ~= nil then
        for _, child in ipairs(childs) do
            if EntityGetName(child) == "inventory_quick" then
                inven = child
            end
        end
    end
    local wands = {}
    if inven ~= nil then
        local items = EntityGetAllChildren(inven)
        for _, child_item in ipairs(items) do
            if EntityHasTag(child_item, "wand") then
                wands[_] = child_item
            end
        end
    end

    return wands or nil
end

function GetWandSpells(id)
    local childs = EntityGetAllChildren(id)
    local inven = {}
    if childs ~= nil then
        for _, child in ipairs(childs) do
            if EntityHasTag(child, "card_action") then
                inven[_] = child
            end
        end
    end
    return inven or nil
end

function force_refresh_wands()
    local inventory2 = EntityGetFirstComponent( get_player(), "Inventory2Component" );
    if inventory2 ~= nil then
        ComponentSetValue2( inventory2, "mForceRefresh", true );
        ComponentSetValue2( inventory2, "mActualActiveItem", 0 );
    end
end

function spawn_prop(entity_path, x, y)
    async(function()
        local px, py = get_player_pos()

        local dummy = EntityLoad("data/entities/dummy_hax.xml", px + x, py + y)
        wait(60)
        local dummy_x, dummy_y = EntityGetTransform(dummy)
        EntityKill(dummy)
        local from_above = Random(0, 1)
        if from_above > 0 then
            local rhit, rx, ry = Raytrace(dummy_x, dummy_y - 35, dummy_x,
                                          dummy_y - 180)
            if rhit then
                dummy_y = ry + 25
            else
                dummy_y = dummy_y - 160
            end
        end
        EntityLoad(entity_path, dummy_x, dummy_y)
    end)
end

function spawn_twitch_stuff(name, amount)
    async(function()
        local x, y = get_player_pos()
        y = y + 110
        local twitch_things = {}
        for i = 1, amount do
            local dx = generate_value_in_range(5, 160, 0)
            local dummy =
                EntityLoad("data/twitch/" .. name .. ".xml", x + dx, y)
            twitch_things[i] = dummy
        end

        wait(60)

        for i, dummy in ipairs(twitch_things) do
            local dummy_x, dummy_y = EntityGetTransform(dummy)

            local from_above = Random(0, 1)
            if from_above > 0 then
                local rhit, rx, ry = Raytrace(dummy_x, dummy_y - 30, dummy_x,
                                              dummy_y - 160)
                if rhit then
                    dummy_y = ry + 20
                else
                    dummy_y = dummy_y - 170
                end
                EntitySetTransform(dummy, dummy_x, dummy_y)
            end
        end
    end)
end

function empty_player_stomach()
    local player = get_player()
    if player ~= nil then
        local stomach = EntityGetFirstComponent(player, "IngestionComponent")
        if stomach ~= nil then
            ComponentSetValue(stomach, "ingestion_size", "0")
        end
    end
end

local usedNames = {}
function append_viewer_name(entity)
    async(function()
        if #twitch_viewers == 0 then return end
        --if #twitch_viewers == 0 then  table.insert(twitch_viewers, 'Miczu'); table.insert(twitch_viewers, 'Soler91') end
        local x, y = get_player_pos()
        SetRandomSeed( GameGetFrameNum(), x + y + tonumber( entity ) )
		local name, index
		local attempt = 0
		repeat
			attempt = attempt + 1
			index = Random(1, #twitch_viewers)
			name = twitch_viewers[index]
		until(attempt > 4 or usedNames[name] == nil)
		table.remove(twitch_viewers, index)
		usedNames[name] = 1
		if (#twitch_viewers * 3 > #usedNames * 4) then
			usedNames = {}
		end
        wait(5)
		if EntityGetIsAlive(entity) == false then return end
        local text = {
            string = name,
            offset_y = "-6",
            scale_x="0.7",
            scale_y="0.7"
        }
        local name_entity = EntityCreateNew("twitch_name")
        EntityAddComponent(name_entity, "InheritTransformComponent", {
            _tags = "enabled_in_world",
            use_root_parent = "1"
        })
        append_text(name_entity, text)

        EntityAddChild(entity, name_entity)
        EntityAddTag(entity, "dont_append_name")
    end)
end

function append_text(entity, text)
    if EntityGetIsAlive(entity) == false then return nil end
    text.offset_x = string.len(text.string)*1.9
    local component = EntityAddComponent( entity, "SpriteComponent", {
        _tags = "enabled_in_world",
        image_file = text.font or "data/fonts/font_pixel_white.xml",
        emissive = "1",
        is_text_sprite = "1",
        offset_x = text.offset_x or "0",
        offset_y = text.offset_y or "0",
        alpha = text.alpha or "1",
        update_transform = "1",
        update_transform_rotation = "0",
        text = text.string or "",
        has_special_scale = "1",
        special_scale_x = text.scale_x or "1",
        special_scale_y = text.scale_y or "1",
        z_index = "-9000"
    } )
    return component
end

function update_text(parent, child, text)
    if EntityGetIsAlive(parent) == false then return nil end
    ComponentSetValue( child, "text", text )
end

function remove_text(parent, child)
    if EntityGetIsAlive(parent) == false then return nil end
    EntityRemoveComponent(parent, child)
end

function make_badge(info)
    if info == nil then
        return nil
    end
    local eid = EntityCreateNew( info.long_name )
    local badge = EntityAddComponent(eid, "UIIconComponent", {
        icon_sprite_file= info.sprite or "mods/gkbrkn_noita/files/gkbrkn/badges/badge.png",
        name= info.name or "WIP",
        description= info.description or "Nothing to see here."
    })

    return eid, badge
end

function remove_badge(name) 
    local eid = EntityGetWithName(name)
    EntityKill(eid)
end

function GetBestPoint(x, y, distance, resolution)
	local bestScore = -10
	local bestAngle = 0
	local bestDistance = 0
	local seed = math.floor(math.random(0,resolution))
	
	for i = seed, resolution - 1 + seed do
	
		local hit2, hx2, hy2, a2 = Raycast(x, y, distance, i/resolution - (1/resolution/2))
		local hit1, hx1, hy1, a1 = Raycast(x, y, distance, i/resolution)
		local hit3, hx3, hy3, a3 = Raycast(x, y, distance, i/resolution + (1/resolution/2))
		
		local mid = dist(x, y, hx1, hy1)
		local score = mid + dist(x, y, hx2, hy2) + dist(x, y, hx3, hy3)
		if(bestScore < score) then
			bestScore = score
			bestAngle = a1
			bestDistance = math.sqrt(mid)
		end
	end
	
	return bestAngle, bestDistance
end

function Raycast(x, y, distance, fraction)
	local angle = fraction * math.pi * 2
	x, y = ToPointFromDirection(x,y,10, angle)
	local sx, sy = ToPointFromDirection(x,y,distance-10, angle)
	local hit, hx, hy = RaytraceSurfaces(x, y, sx, sy)--RaytraceSurfaces RaytracePlatforms
	return hit, hx, hy, angle;
end

function ToPointFromDirection(x, y, distance, angle)
	local sx, sy = x + math.cos(angle) * distance,
				   y + math.sin(angle) * distance;
    return sx, sy
end

function dist(x, y, sx, sy)
	return ((sx-x)*(sx-x)) + ((sy-y)*(sy-y))
end

function spawn_entity_in_view_random_angle(filename, min_distance, max_distance, safety, callback, inEmpty)
	safety = safety or 20
	if inEmpty ~= true then inEmpty = false end
	
	async(function()
		local x, y, hit, hx, hy, angle, distance
		repeat
			wait(1)
			local fraction = math.random();
			distance = Random(min_distance, max_distance) + safety;
			x, y = get_player_pos()
			hit, hx, hy, angle = Raycast(x, y, distance, fraction)
		until(hit == inEmpty and dist(x, y, hx, hy) > (min_distance*min_distance))
		
		hx, hy = ToPointFromDirection(x, y, distance - safety, angle)
		local eid = EntityLoad(filename, hx, hy)
		if(callback) then callback(eid) end
	end)
end

function chat_follower(username, entity_path)
    local x, y = get_player_pos()--"data/entities/animals/duck.xml"
    local follower = EntityLoad(entity_path, x, y)

    local text = {
        string = username,
        offset_y = "-6",
        scale_x="0.7",
        scale_y="0.7"
    }
    local name_entity = EntityCreateNew("twitch_name")
    EntityAddComponent(name_entity, "InheritTransformComponent", {
        _tags = "enabled_in_world",
        use_root_parent = "1"
    })
    append_text(name_entity, text)

    EntityAddChild(follower, name_entity)
    EntityAddTag(follower, "dont_append_name")

    local animal_ais = EntityGetComponent(follower, "AnimalAIComponent") or {}
    for _, animal_ai in pairs(animal_ais) do
        --ComponentSetValue( animal_ai, "preferred_job", "JobAttack" );
        ComponentSetValue(animal_ai, "sense_creatures", "1")
        ComponentSetValue(animal_ai, "aggressiveness_min", "100")
        ComponentSetValue(animal_ai, "aggressiveness_max", "100")
        ComponentSetValue(animal_ai, "creature_detection_check_every_x_frames", "10")
        ComponentSetValue(animal_ai, "hide_from_prey", "0")
        ComponentSetValue(animal_ai, "attack_only_if_attacked", "0")
        ComponentSetValue(animal_ai, "attack_ranged_min_distance", "0")
        ComponentSetValue(animal_ai, "dont_counter_attack_own_herd", "1")
        ComponentSetValue(animal_ai, "escape_if_damaged_probability", "0")
        ComponentSetValue(animal_ai, "max_distance_to_move_from_home", "192")
    end

    -- movement speed bonus
    local character_platforming = EntityGetFirstComponent(follower, "CharacterPlatformingComponent")
    local speed_multiplier = 2
    if character_platforming ~= nil then
        local fly_velocity_x = tonumber(ComponentGetMetaCustom(character_platforming, "fly_velocity_x"))
        ComponentSetMetaCustom(character_platforming, "fly_velocity_x", tostring(fly_velocity_x * speed_multiplier))
        ComponentSetValue(character_platforming, "fly_smooth_y", "0")
        ComponentSetValue(character_platforming, "fly_speed_mult", tostring(fly_velocity_x * speed_multiplier))
        ComponentSetValue(character_platforming, "fly_speed_max_up", tostring(fly_velocity_x * speed_multiplier))
        ComponentSetValue(character_platforming, "fly_speed_max_down", tostring(fly_velocity_x * speed_multiplier))
        ComponentSetValue(character_platforming, "fly_speed_change_spd", tostring(fly_velocity_x * speed_multiplier))
    end

    local genomes = EntityGetComponent(follower, "GenomeDataComponent") or {}
    for _, genome_data in pairs(genomes) do
        ComponentSetValue(genome_data, "herd_id", "player")
    end

    EntityAddComponent(
        follower,
        "LuaComponent",
        {
            script_source_file = "data/scripts/toofarteleport.lua",
            execute_on_added = "1",
            execute_every_n_frame = "20",
            execute_times = "-1"
        }
    )

    EntityAddComponent(
        follower,
        "LuaComponent",
        {
            script_source_file = "data/scripts/player_home.lua",
            execute_on_added = "1",
            execute_every_n_frame = "30",
            execute_times = "-1"
        }
    )

    EntityRemoveTag(follower, "homing_target")
end

function spawn_healer_pikku( username, message )
    local PIKKU_TYPES = {
        Healer=1,
        Tank=2,
        Warrior=3,
        Bomber=4,
    };
    local PIKKU_TITLES = {
        [PIKKU_TYPES.Healer]=" the Healer",
        [PIKKU_TYPES.Tank]=" the Tank",
        [PIKKU_TYPES.Warrior]=" the Fighter",
        [PIKKU_TYPES.Bomber]=" the Bomber",
    }
    local PIKKU_TAGS = {
        ["#healer"] = 1,
        ["#cleric"] = 1,
        ["#tank"] = 2,
        ["#warrior"] = 3,
        ["#fighter"] = 3,
        ["#bomber"] = 4,
        ["#kamikaze"] = 4,
        ["#boom"] = 4,
    }
    local x, y = get_player_pos();
    local pikku = EntityLoad( "data/entities/pikku.xml", x, y );
    SetRandomSeed( GameGetFrameNum(), x + y + tonumber( pikku ) );
    local pikku_type = Random( 1, 4 );
    
    if message ~= nil then
        message = message:lower();
        for tag,type in pairs( PIKKU_TAGS ) do
            if string.find( message, tag ) then
                pikku_type = type;
                break;
            end
        end
    end
    
    EntityAddComponent( pikku, "SpriteComponent", {
        _tags = "enabled_in_world",
        image_file = "data/fonts/font_pixel_white.xml",
        emissive = "1",
        is_text_sprite = "1",
        offset_x = "30",
        alpha = "0.67",
        offset_y = "-4",
        update_transform = "1",
        update_transform_rotation = "0",
        text = username..PIKKU_TITLES[pikku_type],
        has_special_scale = "1",
        special_scale_x = "0.5",
        special_scale_y = "0.5",
        z_index = "-9000"
    } );

    -- here is an unlimited charm effect
    -- this isn't needed anymore after changing player genome, causes annoying pathing behaviour
    --[[
    local game_effect = GetGameEffectLoadTo( pikku, "CHARM", true );
    if game_effect ~= nil then
        ComponentSetValue( game_effect, "frames", -1 );
    end
    ]]

    -- pikku typing
    if pikku_type == PIKKU_TYPES.Healer then
        local animal_ais = EntityGetComponent( pikku, "AnimalAIComponent" ) or {};
        for _, animal_ai in pairs( animal_ais ) do
            ComponentSetValue( animal_ai, "attack_melee_enabled", "0" );
            ComponentSetValue( animal_ai, "attack_dash_enabled", "0" );
            ComponentSetValue( animal_ai, "attack_ranged_enabled", "1" );
            ComponentSetValue( animal_ai, "attack_ranged_entity_file", "data/entities/projectiles/healshot.xml" );
            ComponentSetValue( animal_ai, "tries_to_ranged_attack_friends", "1" );
        end
    elseif pikku_type == PIKKU_TYPES.Warrior then
        local animal_ais = EntityGetComponent( pikku, "AnimalAIComponent" ) or {};
        for _, animal_ai in pairs( animal_ais ) do
            ComponentSetValue( animal_ai, "attack_melee_enabled", "1" );
            ComponentSetValue( animal_ai, "attack_dash_enabled", "0" );
            ComponentSetValue( animal_ai, "attack_ranged_enabled", "1" );
            ComponentSetValue( animal_ai, "attack_ranged_entity_file", "data/entities/projectiles/deck/light_bullet.xml" );
            ComponentSetValue( animal_ai, "attack_ranged_frames_between", "20" );
        end
    elseif pikku_type == PIKKU_TYPES.Bomber then
        local animal_ais = EntityGetComponent( pikku, "AnimalAIComponent" ) or {};
        for _, animal_ai in pairs( animal_ais ) do
            ComponentSetValue( animal_ai, "attack_melee_enabled", "0" );
            ComponentSetValue( animal_ai, "attack_dash_enabled", "1" );
            ComponentSetValue( animal_ai, "attack_dash_damage", "0" );
            ComponentSetValue( animal_ai, "attack_ranged_enabled", "1" );
            ComponentSetValue( animal_ai, "attack_ranged_max_distance", "12" );
            ComponentSetValue( animal_ai, "attack_ranged_frames_between", "1" );
            ComponentSetValue( animal_ai, "attack_ranged_entity_file", "data/entities/projectiles/deck/explosion.xml" );
        end
    elseif pikku_type == PIKKU_TYPES.Tank then
        local animal_ais = EntityGetComponent( pikku, "AnimalAIComponent" ) or {};
        for _, animal_ai in pairs( animal_ais ) do
            ComponentSetValue( animal_ai, "attack_melee_enabled", "0" );
            ComponentSetValue( animal_ai, "attack_dash_enabled", "1" );
            ComponentSetValue( animal_ai, "attack_ranged_enabled", "0" );
            ComponentSetValue( animal_ai, "attack_dash_damage", "0" );
            ComponentSetValue( animal_ai, "attack_ranged_entity_file", "data/entities/projectiles/healshot.xml" );
        end

        local x, y = EntityGetTransform( pikku );
        local hitbox = EntityGetFirstComponent( pikku, "HitboxComponent" );
        local radius = 10;
        local shield = EntityLoad( "data/entities/misc/animal_energy_shield.xml", x, y );
        local inherit_transform = EntityGetFirstComponent( shield, "InheritTransformComponent" );
        if inherit_transform ~= nil then
            ComponentSetValue( inherit_transform, "parent_hotspot_tag", "shield_center" );
        end
        local emitters = EntityGetComponent( shield, "ParticleEmitterComponent" ) or {};
        for _,emitter in pairs( emitters ) do
            ComponentSetValueValueRange( emitter, "area_circle_radius", radius, radius );
        end
        local energy_shield = EntityGetFirstComponent( shield, "EnergyShieldComponent" );
        ComponentSetValue( energy_shield, "radius", tostring( radius ) );

        local hotspot = EntityAddComponent( pikku, "HotspotComponent",{
            _tags="shield_center"
        } );
        ComponentSetValueVector2( hotspot, "offset", 0, -4 );

        if shield ~= nil then EntityAddChild( pikku, shield ); end
    end

    local animal_ais = EntityGetComponent( pikku, "AnimalAIComponent" ) or {};
    for _, animal_ai in pairs( animal_ais ) do
        --ComponentSetValue( animal_ai, "preferred_job", "JobAttack" );
        ComponentSetValue( animal_ai, "sense_creatures", "1" );
        ComponentSetValue( animal_ai, "aggressiveness_min", "100" );
        ComponentSetValue( animal_ai, "aggressiveness_max", "100" );
        ComponentSetValue( animal_ai, "creature_detection_check_every_x_frames", "10" );
        ComponentSetValue( animal_ai, "hide_from_prey", "0" );
        ComponentSetValue( animal_ai, "attack_only_if_attacked", "0" );
        ComponentSetValue( animal_ai, "attack_ranged_min_distance", "0" );
        ComponentSetValue( animal_ai, "dont_counter_attack_own_herd", "1" );
        ComponentSetValue( animal_ai, "escape_if_damaged_probability", "0" );
        ComponentSetValue( animal_ai, "max_distance_to_move_from_home", "192" );
    end

    -- movement speed bonus
    local character_platforming = EntityGetFirstComponent( pikku, "CharacterPlatformingComponent" );
    local speed_multiplier = 2;
    if character_platforming ~= nil then
        local fly_velocity_x = tonumber( ComponentGetMetaCustom( character_platforming, "fly_velocity_x" ) );
        ComponentSetMetaCustom( character_platforming, "fly_velocity_x", tostring( fly_velocity_x * speed_multiplier ) );
        ComponentSetValue( character_platforming, "fly_smooth_y", "0" );
        ComponentSetValue( character_platforming, "fly_speed_mult", tostring( fly_velocity_x * speed_multiplier ) );
        ComponentSetValue( character_platforming, "fly_speed_max_up", tostring( fly_velocity_x * speed_multiplier ) );
        ComponentSetValue( character_platforming, "fly_speed_max_down", tostring( fly_velocity_x * speed_multiplier ) );
        ComponentSetValue( character_platforming, "fly_speed_change_spd", tostring( fly_velocity_x * speed_multiplier ) );
    end

    -- add iframes
    local damage_models = EntityGetComponent( pikku, "DamageModelComponent" ) or {};
    for _,damage_model in pairs( damage_models ) do
        ComponentSetValue( damage_model, "invincibility_frames", "60" );
    end

    -- set to player genome
    local genomes = EntityGetComponent( pikku, "GenomeDataComponent" ) or {};
    for _,genome_data in pairs( genomes ) do
        ComponentSetValue( genome_data, "herd_id", "player" );
    end

    -- add pikku tracker (requires ti_pikku_tracker mod to function)
    EntityAddComponent( pikku, "VariableStorageComponent", {
        _tags="twitch_username,enabled_in_world,enabled_in_hand,enabled_in_inventory",
        value_string=username
    } );

    EntityAddComponent( pikku, "VariableStorageComponent", {
        _tags="spawn_frame,enabled_in_world,enabled_in_hand,enabled_in_inventory",
        value_string=tostring( GameGetFrameNum() )
    } );

    EntityAddComponent( pikku, "LuaComponent", {
        script_damage_received="mods/ti_pikku_tracker/files/pikku_damage_received.lua"
    } );

    -- remove homing tag
    EntityRemoveTag( pikku, "homing_target" );
end


function add_icon_effect(icon_file, name, description, duration, startFunction, endFunction)
    if duration < 0 then
        return
    end
    
    startFunction = startFunction or nil
    endFunction = endFunction or nil
    
    local isInEffect = is_icon_effect_active(name)
    
    if isInEffect ~= false then
        extend_icon_effect(name, duration)
    else
        start_icon_effect(icon_file, name, description, duration, startFunction, endFunction)
    end
end

function start_icon_effect(icon_file, name, description, duration, startFunction, endFunction)
    --GamePrint("New")
    local pid = get_player()
    if pid ~= nil then

        local cid = EntityAddComponent2( pid, "UIIconComponent",
        {
            name = name,
            description = description,
            icon_sprite_file = icon_file,
            display_above_head = false,
            display_in_hud = true,
            is_perk = true
        })
        add_icon_effect_state(name, duration)
        if startFunction ~= nil then
            startFunction()
        end
        end_icon_effect(name, pid, cid, duration, endFunction)
    else
        async(function()
            wait(60)
            add_icon_effect(icon_file, name, description, duration-60, startFunction, endFunction)
        end)
    end
end

function end_icon_effect(name, pid, cid, duration, endFunction)
    async(function()
        wait(duration+1)
        if is_icon_effect_active(name) ~= true then
            EntityRemoveComponent(pid, cid)
            remove_icon_effect_state(name)
            if endFunction ~= nil then
                endFunction()
            end
        else
            local remaining = get_remaining_duration(name)
            end_icon_effect(name, pid, cid, remaining, endFunction)
        end
    end)
end

function add_icon_effect_state(name, duration)
    local now = GameGetFrameNum()
    local final = now + duration
    
    GlobalsSetValue(name, "" .. now .. "|" .. final)
end

function extend_icon_effect(name, duration)
    local now = GameGetFrameNum()
    local value = GlobalsGetValue(name, "" .. now .. "|" .. now)
    local nowFinal = split(value, "%d+")
    local final = duration + tonumber(nowFinal[2])
    local new = nowFinal[1] .. "|" .. final
    GlobalsSetValue(name, new)
end

function is_icon_effect_active(name)
    local now = GameGetFrameNum()
    local value = GlobalsGetValue(name, "" .. now .. "|" .. now)
    local nowFinal = split(value, "%d+")
    if (tonumber(nowFinal[1]) < now) and (now < tonumber(nowFinal[2])) then
        return true
    end
    return false
end

function get_remaining_duration(name)
    local now = GameGetFrameNum()
    local value = GlobalsGetValue(name, "" .. now .. "|" .. now)
    local nowFinal = split(value, "%d+")

    return tonumber(nowFinal[2]) - now
end

function remove_icon_effect_state(name)
    GlobalsGetValue(name, "")
    return
end

function split(text, delimiter)
    local arr = {}
    for i in string.gmatch(text, delimiter) do
        table.insert(arr, i)
    end
    return arr
end

function speedup_enemy(entity_id)
    for _, perk in ipairs(perk_list) do
        if perk.id == "MOVEMENT_FASTER" or perk.id == "FASTER_LEVITATION" then
            give_perk_to_enemy(perk, entity_id, 0)
        end
    end
end