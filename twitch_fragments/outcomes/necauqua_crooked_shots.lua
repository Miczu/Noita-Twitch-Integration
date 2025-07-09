--Crooked Shots
--Makes projectiles fire at a random offset angle
--curses
--100
--Your projectiles fire at a random offset angle
function twitch_necauqua_crooked_shots()
    async(effect_necauqua_crooked_shots)
end

---@param effect entity_id
local function set_random_angle(effect)
    local too_straight = 15
    local angle = math.random(360 - too_straight * 2) + too_straight
    ComponentSetValue2(EntityGetFirstComponent(effect, "VariableStorageComponent"), "value_int", angle)
end

---@async
function effect_necauqua_crooked_shots()
    local player = nil
    while not player do
        wait(1);
        player = EntityGetWithTag("player_unit")[1]
    end

    for _, child in pairs(EntityGetAllChildren(player) or {}) do
        if EntityGetName(child) == "necauqua_crooked_shots" then
            set_random_angle(child)
            local comp = EntityGetFirstComponentIncludingDisabled(child, "GameEffectComponent")
            ComponentSetValue2(comp, "frames", ComponentGetValue2(comp, "frames") + 2700)
            return
        end
    end

    local x, y = EntityGetTransform(player)
    local effect = EntityLoad("mods/twitch-integration/files/entities/misc/effect_crooked_shots.xml", x, y)
    set_random_angle(effect)

    EntityAddChild(player, effect)
end
