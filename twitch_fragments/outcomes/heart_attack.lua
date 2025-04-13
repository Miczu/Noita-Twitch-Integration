--Heart Attack
--Heartache x3
--curses
--80
--Stacks a 15-second heartache modifier on the player every 5 seconds, 3 times in a row
function twitch_heart_attack()
    async(effect_heart_attack)
end

function effect_heart_attack()
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;
    
    if player then
        local x, y = EntityGetTransform(player)
        local heart_attack = EntityGetAllChildren(player, "heart_attack")[1] or nil
        if heart_attack == nil then
            heart_attack = EntityLoad("mods/twitch-integration/files/entities/misc/effect_heart_attack.xml", x, y)
            local damage_comp = EntityGetFirstComponent(player, "DamageModelComponent")
            local max_hp = ComponentGetValue2(damage_comp, "max_hp")
            local var_comps = EntityGetComponent(heart_attack, "VariableStorageComponent")
            local max_max_hp = var_comps[1]
            local last_max_hp = var_comps[2]
            ComponentSetValue2(max_max_hp, "value_float", max_hp)
            ComponentSetValue2(last_max_hp, "value_float", max_hp)
            EntityAddChild(player, heart_attack)
        end
        local instance = EntityLoad("mods/twitch-integration/files/entities/misc/effect_heart_attack_instance.xml", x, y)
        local frame_spawned_comp = EntityGetFirstComponent(instance, "VariableStorageComponent")
        ComponentSetValue2(frame_spawned_comp, "value_int", GameGetFrameNum())
        EntityAddChild(heart_attack, instance)
    end
end