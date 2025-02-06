--Heart Attack
--Heartache x3
--curses
--150
--Stacks a 15-second heartache modifier on the player every 5 seconds, 3 times in a row
function twitch_heart_attack()
    local player = EntityGetWithTag("player_unit")[1]
    if player then
        local x, y = EntityGetTransform(player)
        local damage_comp = EntityGetFirstComponent(player, "DamageModelComponent")
        local max_hp = ComponentGetValue2(damage_comp, "max_hp")
        local heart_attack = EntityLoad("mods/twitch-integration/files/entities/misc/effect_heart_attack.xml", x, y)
        local var_comps = EntityGetComponent(heart_attack, "VariableStorageComponent")
        local max_max_hp = var_comps[1]
        local last_max_hp = var_comps[2]
        ComponentSetValue2(max_max_hp, "value_float", max_hp)
        ComponentSetValue2(last_max_hp, "value_float", max_hp)
        EntityAddChild(player, heart_attack)
    end
end