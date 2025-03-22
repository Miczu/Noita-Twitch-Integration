--Replace wand
--Was it always like this ???
--unknown
--50
--todo
function twitch_wand_replacement()
    local inventory = GetInven()
    local inventory_items = GetWands()

    if inventory_items ~= nil then
        local wandToReplace = wand_replacement_pick_wand(inventory_items, table.getn(inventory_items))
        local replaced_wand = inventory_items[wandToReplace]

        EntityRemoveFromParent(replaced_wand)
        EntityKill(replaced_wand)

        local item_entity = nil
        
        local x, y = get_player_pos()
        local range = math.min(math.max(400, y / 8), 1000)

        local rnd = Random(0, range)
        SetRandomSeed(x+rnd, y-rnd)
        x = x - 3000
        y = y - 3000
        
        if rnd < 300 then
            item_entity = EntityLoad("data/entities/items/wand_level_01.xml", x, y)
        elseif rnd < 550 then
            item_entity = EntityLoad("data/entities/items/wand_level_02.xml", x, y)
        elseif rnd < 800 then
            item_entity = EntityLoad("data/entities/items/wand_level_03.xml", x, y)
        elseif rnd < 995 then
            item_entity = EntityLoad("data/entities/items/wand_level_04.xml", x, y)
        else
            item_entity = EntityLoad("data/entities/items/wand_level_05.xml", x, y)
        end
        EntityAddChild(inventory, item_entity)
    end
    force_refresh_wands()
end

function wand_replacement_pick_wand(wands, count)
    local result = math.random(1, count)
	local hitList = {
		"BLACK_HOLE",
		"TELEPORTATION_FIELD",
		"TELEPORT_PROJECTILE",
		"TELEPORT_PROJECTILE_SHORT",
		"BLACK_HOLE_DEATH_TRIGGER",
		"WORM_SHOT",
		"WHITE_HOLE"
	}

	for i = 1, count do
		if has_action_id_in_children(wands[i], hitList) then
			return i
		end
	end	
	
	return result
end

function has_action_id_in_children(entityId, action_ids)
    local children = EntityGetAllChildren(entityId)
    if children == nil then
        return false
    end

    for _, child in ipairs(children) do
        if EntityHasTag(child, "card_action") then
            local item_action_components = EntityGetComponentIncludingDisabled(child, "ItemActionComponent")
            if item_action_components ~= nil then
                for _, component_id in ipairs(item_action_components) do
                    local action_id = ComponentGetValue2(component_id, "action_id")
                    if action_id ~= nil then
                        for _, target_action_id in ipairs(action_ids) do
                            if action_id == target_action_id then
                                return true
                            end
                        end
                    end
                end
            end
        end
    end

    return false
end
