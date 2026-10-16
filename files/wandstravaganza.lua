local M = {}
local active_until = -1
local next_scan = 0
local status_entity = 0
local tracked = {}
local pending = {}
local retry_after = {}
local selected = {}
local activation = 0
local selection_seed = 0
local wand_chance = 0.90
local duration = 600
local root_path = "mods/twitch-integration/"

local function alive(entity)
    return entity ~= nil and entity ~= 0 and EntityGetIsAlive(entity)
end

local function is_player(entity)
    return alive(entity) and (EntityHasTag(entity, "player_unit") or EntityHasTag(entity, "player"))
end

local function dead(enemy)
    if not alive(enemy) then return true end
    local damage = EntityGetFirstComponentIncludingDisabled(enemy, "DamageModelComponent")
    return damage ~= nil and ComponentGetValue2(damage, "hp") <= 0
end

local function get_wand_tier(biome)
    local name = string.lower(biome or "")
    local zones = {
        { "coalpits", 2 }, { "coal_pit", 2 },
        { "snowcave", 3 }, { "snow_cave", 3 },
        { "snowcastle", 3 }, { "snow_castle", 3 },
        { "jungle", 4 }, { "vault", 5 }, { "crypt", 6 }
    }
    for _, zone in ipairs(zones) do
        if string.find(name, zone[1], 1, true) then return zone[2] end
    end
    return 1
end

local function has_wand(enemy)
    for _, item in ipairs(GameGetAllInventoryItems(enemy) or {}) do
        local ability = EntityGetFirstComponentIncludingDisabled(item, "AbilityComponent")
        if EntityHasTag(item, "wand") or (ability and ComponentGetValue2(ability, "use_gun_script")) then
            return true
        end
    end
    return false
end

local function select_wand(enemy, wand)
    local inventory = EntityGetFirstComponentIncludingDisabled(enemy, "Inventory2Component")
    if inventory then
        ComponentSetValue2(inventory, "mActiveItem", wand)
        ComponentSetValue2(inventory, "mForceRefresh", true)
    end
end

local function cleanup_wands()
    for wand, enemy in pairs(tracked) do
        if not alive(wand) then
            tracked[wand] = nil
        elseif is_player(EntityGetRootEntity(wand)) then
            tracked[wand] = nil
        elseif dead(enemy) then
            EntityKill(wand)
            tracked[wand] = nil
        end
    end
end

local function resolve_pickups(frame)
    for enemy, entry in pairs(pending) do
        local wand = entry.wand
        if not alive(wand) then
            pending[enemy] = nil
        elseif is_player(EntityGetRootEntity(wand)) then
            pending[enemy] = nil
        elseif dead(enemy) then
            EntityKill(wand)
            pending[enemy] = nil
        elseif EntityGetRootEntity(wand) == enemy then
            tracked[wand] = enemy
            select_wand(enemy, wand)
            pending[enemy] = nil
        elseif frame >= entry.deadline then
            EntityKill(wand)
            pending[enemy] = nil
            retry_after[enemy] = frame + 60
        end
    end
end

local function distribute_wands(frame)
    for _, enemy in ipairs(EntityGetWithTag("enemy") or {}) do
        local pickup = EntityGetFirstComponentIncludingDisabled(enemy, "ItemPickUpperComponent")
        if pickup and not pending[enemy] and not dead(enemy) and frame >= (retry_after[enemy] or 0) and not has_wand(enemy) then
            if selected[enemy] == nil then
                selected[enemy] = ProceduralRandomf(enemy, selection_seed, 0, 1) < wand_chance
            end
            if selected[enemy] then
                local x, y = EntityGetTransform(enemy)
                if x ~= nil and y ~= nil then
                    local tier = get_wand_tier(BiomeMapGetName(x, y))
                    local wand = EntityLoad(string.format("data/entities/items/wand_level_%02d.xml", tier), x, y)
                    if alive(wand) then
                        EntityAddTag(wand, "ti_wandstravaganza_wand")
                        pending[enemy] = { wand = wand, deadline = frame + 30 }
                        GamePickUpInventoryItem(enemy, wand)
                    else
                        retry_after[enemy] = frame + 60
                    end
                end
            end
        end
    end
    resolve_pickups(frame)
end

local function clear_status()
    if alive(status_entity) then EntityKill(status_entity) end
    status_entity = 0
end

local function update_status(player, remaining)
    if not is_player(player) then return end
    if alive(status_entity) and EntityGetRootEntity(status_entity) ~= player then clear_status() end
    if not alive(status_entity) then
        local x, y = EntityGetTransform(player)
        status_entity = EntityLoad(root_path .. "files/effects/wandstravaganza.xml", x, y)
        if not alive(status_entity) then return end
        EntityAddChild(player, status_entity)
    end
    local effect = EntityGetFirstComponentIncludingDisabled(status_entity, "GameEffectComponent")
    if effect then ComponentSetValue2(effect, "frames", remaining) end
end

function M.start(player)
    if not is_player(player) then return false end
    local frame = GameGetFrameNum()
    activation = activation + 1
    selection_seed = frame + activation * 7919
    selected = {}
    active_until = frame + duration
    next_scan = frame
    update_status(player, duration)
    distribute_wands(frame)
    next_scan = frame + 1
    return true
end

function M.update()
    local frame = GameGetFrameNum()
    resolve_pickups(frame)
    cleanup_wands()
    if frame < active_until then
        local players = EntityGetWithTag("player_unit") or {}
        if not players[1] then players = EntityGetWithTag("player") or {} end
        update_status(players[1], active_until - frame)
        if frame >= next_scan then
            distribute_wands(frame)
            next_scan = frame + 1
        end
    elseif status_entity ~= 0 then
        clear_status()
    end
    if frame % 600 == 0 then
        for enemy, retry in pairs(retry_after) do
            if not alive(enemy) or retry <= frame then retry_after[enemy] = nil end
        end
    end
end

return M
