function shot(shot_id)
    local entity_id = GetUpdatedEntityID()
    local x, y = EntityGetTransform(entity_id)
    local owner = EntityGetClosestWithTag(x, y, "mortal")
    local cd = 6
    local currFrame = GameGetFrameNum()
    local cdStore = nil
    local components = EntityGetComponentIncludingDisabled(owner, "VariableStorageComponent") or {}
    for _, c in ipairs(components) do
        if ComponentGetValue2(c, "name") == "moneyShotCD" then
            cdStore = c
            break
        end
    end
    if cdStore == nil then
        cdStore = EntityAddComponent2(owner, "VariableStorageComponent", {name = "moneyShotCD", value_int = 0})
    end
    if currFrame < ComponentGetValue2(cdStore, "value_int") then
        return
    end
    ComponentSetValue2(cdStore, "value_int", currFrame + cd)
    local moneyToRemove = 5
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
                local hp = ComponentGetValue2(dmg_model, "hp")
                if hp > 5/25 then
                    local dmg = 3/25
                    EntityInflictDamage(owner,dmg,"DAMAGE_CURSE","If this message has appeared there is a bug and any associated bets or predictions should be redone",0, 0, 0,entity_id)
                end
            end
        end
    end
end