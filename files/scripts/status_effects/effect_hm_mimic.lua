
local entity_id = GetUpdatedEntityID()
local player = EntityGetParent(entity_id)
local x, y = EntityGetTransform( entity_id )

local regenid = 0
local refreshid = 0

local targets = EntityGetWithTag( "drillable" ) or {}

if ( #targets > 0 ) then
    for k=1,#targets
    do local v = targets[k]
		local comp = EntityGetFirstComponentIncludingDisabled(v,"LuaComponent")
		if ComponentGetValue2(comp,"script_item_picked_up") == "data/scripts/items/heart_fullhp_temple.lua" then
			regenid = v
		elseif ComponentGetValue2(comp,"script_item_picked_up") == "data/scripts/items/spell_refresh.lua" then
			refreshid = v
		end
	end
end

if regenid ~= 0 and refreshid ~= 0 then
	--Both health refresh and spell refresh are found, run the numbers and turn one into a mimic
	-- 10 hp = 9%
	-- 25 hp = 18%
	-- 50 hp = 34%
	-- 75+ hp = 50%
	local comp = EntityGetFirstComponentIncludingDisabled(player,"DamageModelComponent")
	local hp = ComponentGetValue2(comp,"hp")
	local target_id = 0
	local output = ""
	
	local rng = ((math.floor((hp * 25) + 20) / 100) * 0.5)
	rng = math.min(math.floor(rng * 100),50)

	math.randomseed(x + y)
	if math.random(0,100) < rng then
		target_id = regenid
		output = "mods/Twitch-integration/files/entities/animals/dark_alchemist_noprogress.xml"
	else
		target_id = refreshid
		output = "mods/Twitch-integration/files/entities/animals/shaman_wind_noprogress.xml"
	end

	local s_x, s_y = EntityGetTransform(target_id)
	EntityKill(target_id)
	EntityLoad(output,s_x,s_y)
	EntityRemoveFromParent(entity_id)
	EntityKill(entity_id)

end