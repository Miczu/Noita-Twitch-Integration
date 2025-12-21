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
    local dmgPercent = 0.02
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
                local max_hp = ComponentGetValue2(dmg_model, "max_hp")
                if hp > max_hp*0.2 then
                    local dmg = hp * dmgPercent
                    EntityInflictDamage(owner,dmg,"DAMAGE_CURSE","If this message has appeared there is a bug and any associated bets or predictions should be redone",0, 0, 0,entity_id)
                end
            end
        end
    end
end