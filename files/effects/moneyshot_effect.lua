function shot(shot_id)
    local entity_id = GetUpdatedEntityID()
    local x, y = EntityGetTransform(entity_id)
    local owner = EntityGetClosestWithTag(x, y, "mortal")
    local moneyToRemove = 5
    local dmgPercent = 0.03
    local wallet_component = EntityGetFirstComponent(owner, "WalletComponent")
    if (wallet_component) then
        local money = tonumber(ComponentGetValue2(wallet_component, "money"))
        if (money >= moneyToRemove) then
            ComponentSetValue2(wallet_component, "money", money - moneyToRemove)
            local projectile_component = EntityGetFirstComponent(shot_id, "ProjectileComponent")
            if (projectile_component ~= nil) then
                local damage = tonumber(ComponentGetValue2(projectile_component, "damage"))
                ComponentSetValue2(projectile_component, "damage", damage + 0.4)
            end
        else 
            local dmg_model = EntityGetFirstComponent(owner, "DamageModelComponent")
            if dmg_model then
                local max_hp = ComponentGetValue2(dmg_model, "max_hp")
                local dmg = max_hp * dmgPercent
                EntityInflictDamage(owner,dmg,"DAMAGE_CURSE","Bad financial decisions",0, 0, 0,entity_id)
            end
        end
    end
end