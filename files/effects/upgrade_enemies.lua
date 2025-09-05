player = EntityGetWithTag("player_unit")[1]
if player then
    local x, y = EntityGetTransform(player)
    local enemies = EntityGetInRadius(x, y, 150)
    local upgrades = {
        -- thundermage
        ["data/entities/animals/thundermage.xml"] = { xml = "data/entities/animals/thundermage_big.xml" },
        ["data/entities/animals/vault/thundermage.xml"] = { xml = "data/entities/animals/thundermage_big.xml" },
        ["data/entities/animals/crypt/thundermage.xml"] = { xml = "data/entities/animals/thundermage_big.xml" },

        -- firebug
        ["data/entities/animals/firebug.xml"] = { xml = "data/entities/animals/bigfirebug.xml" },

        -- stendari
        ["data/entities/animals/firemage_weak.xml"] = { xml = "data/entities/animals/firemage.xml" },

        -- steve
        ["data/entities/animals/necromancer_shop.xml"] = { xml = "data/entities/animals/necromancer_super.xml" },

        -- worms
        ["data/entities/animals/worm_tiny.xml"] = { xml = "data/entities/animals/meatmaggot.xml" },
        ["data/entities/animals/worm.xml"] = { xml = "data/entities/animals/worm_skull.xml" },
        ["data/entities/animals/crypt/worm.xml"] = { xml = "data/entities/animals/worm_skull.xml" },
        ["data/entities/animals/worm_big.xml"] = { xml = "data/entities/animals/worm_end.xml" },

        -- zombies
        ["data/entities/animals/zombie.xml"] = { xml = "data/entities/animals/bigzombie.xml" },
        ["data/entities/animals/zombie_weak.xml"] = { xml = "data/entities/animals/bigzombie.xml" },

        -- acidshooter
        ["data/entities/animals/acidshooter.xml"] = { xml = "data/entities/animals/crypt/acidshooter.xml" },
        ["data/entities/animals/acidshooter_weak.xml"] = { xml = "data/entities/animals/crypt/acidshooter.xml" },
        ["data/entities/animals/vault/acidshooter.xml"] = { xml = "data/entities/animals/crypt/acidshooter.xml" },

        -- slimeshooter
        ["data/entities/animals/slimeshooter.xml"] = { xml = "data/entities/animals/lasershooter.xml" },
        ["data/entities/animals/slimeshooter_nontoxic.xml"] = { xml = "data/entities/animals/lasershooter.xml" },
        ["data/entities/animals/slimeshooter_weak.xml"] = { xml = "data/entities/animals/lasershooter.xml" },

        -- shotgunner
        ["data/entities/animals/shotgunner.xml"] = { xml = "data/entities/animals/shotgunner_hell.xml" },
        ["data/entities/animals/shotgunner_weak.xml"] = { xml = "data/entities/animals/shotgunner_hell.xml" },
        ["data/entities/animals/drunk/shotgunner.xml"] = { xml = "data/entities/animals/shotgunner_hell.xml" },
        ["data/entities/animals/drunk/shotgunner_weak.xml"] = { xml = "data/entities/animals/shotgunner_hell.xml" },

        -- miner
        ["data/entities/animals/miner.xml"] = { xml = "data/entities/animals/miner_hell.xml" },
        ["data/entities/animals/miner_santa.xml"] = { xml = "data/entities/animals/miner_hell.xml" },
        ["data/entities/animals/miner_weak.xml"] = { xml = "data/entities/animals/miner_hell.xml" },
        ["data/entities/animals/miner_chef.xml"] = { xml = "data/entities/animals/miner_hell.xml" },
        ["data/entities/animals/miner_fire.xml"] = { xml = "data/entities/animals/miner_hell.xml" },
        ["data/entities/animals/drunk/miner.xml"] = { xml = "data/entities/animals/miner_hell.xml" },
        ["data/entities/animals/drunk/miner_weak.xml"] = { xml = "data/entities/animals/miner_hell.xml" },
        ["data/entities/animals/drunk/miner_chef.xml"] = { xml = "data/entities/animals/miner_hell.xml" },
        ["data/entities/animals/drunk/miner_fire.xml"] = { xml = "data/entities/animals/miner_hell.xml" },

        -- sniper
        ["data/entities/animals/sniper.xml"] = { xml = "data/entities/animals/sniper_hell.xml" },
        ["data/entities/animals/drunk/sniper.xml"] = { xml = "data/entities/animals/sniper_hell.xml" },
        ["data/entities/animals/easter/sniper.xml"] = { xml = "data/entities/animals/sniper_hell.xml" },
        ["data/entities/animals/rainforest/sniper.xml"] = { xml = "data/entities/animals/sniper_hell.xml" },
        ["data/entities/animals/vault/sniper.xml"] = { xml = "data/entities/animals/sniper_hell.xml" },

        -- fungus
        ["data/entities/animals/fungus.xml"] = { xml = "data/entities/animals/fungus_big.xml" },
        ["data/entities/animals/rainforest/fungus.xml"] = { xml = "data/entities/animals/fungus_big.xml" },

        -- tank
        ["data/entities/animals/tank.xml"] = { xml = "data/entities/animals/robobase/tank_super.xml" },
        ["data/entities/animals/vault/tank.xml"] = { xml = "data/entities/animals/robobase/tank_super.xml" },

        -- necrobot
        ["data/entities/animals/necrobot.xml"] = { xml = "data/entities/animals/necrobot_super.xml" },

        -- roboguard
        ["data/entities/animals/roboguard.xml"] = { xml = "data/entities/animals/roboguard_big.xml" },
        ["data/entities/animals/vault/roboguard.xml"] = { xml = "data/entities/animals/roboguard_big.xml" },

        -- spirits
        ["data/entities/animals/slimespirit.xml"] = { xml = "data/entities/animals/weakspirit.xml" },
        ["data/entities/animals/confusespirit.xml"] = { xml = "data/entities/animals/weakspirit.xml" },
        ["data/entities/animals/berserkspirit.xml"] = { xml = "data/entities/animals/weakspirit.xml" },

        -- mages
        ["data/entities/animals/wizard_hearty.xml"] = { xml = "data/entities/animals/crypt/wizard_poly.xml" },
        ["data/entities/animals/wizard_homing.xml"] = { xml = "data/entities/animals/crypt/wizard_poly.xml" },
        ["data/entities/animals/wizard_neutral.xml"] = { xml = "data/entities/animals/crypt/wizard_poly.xml" },
        ["data/entities/animals/wizard_returner.xml"] = { xml = "data/entities/animals/crypt/wizard_poly.xml" },
        ["data/entities/animals/wizard_tele.xml"] = { xml = "data/entities/animals/crypt/wizard_poly.xml" },
        ["data/entities/animals/wizard_dark.xml"] = { xml = "data/entities/animals/crypt/wizard_poly.xml" },
        ["data/entities/animals/wizard_twitchy.xml"] = { xml = "data/entities/animals/crypt/wizard_poly.xml" },
        ["data/entities/animals/wizard_weaken.xml"] = { xml = "data/entities/animals/crypt/wizard_poly.xml" },
        ["data/entities/animals/wizard_swapper.xml"] = { xml = "data/entities/animals/crypt/wizard_poly.xml" },
        ["data/entities/animals/crypt/wizard_dark.xml"] = { xml = "data/entities/animals/crypt/wizard_poly.xml" },
        ["data/entities/animals/vault/wizard_dark.xml"] = { xml = "data/entities/animals/crypt/wizard_poly.xml" },
        ["data/entities/animals/crypt/wizard_neutral.xml"] = { xml = "data/entities/animals/crypt/wizard_poly.xml" },
        ["data/entities/animals/crypt/wizard_returner.xml"] = { xml = "data/entities/animals/crypt/wizard_poly.xml" },
        ["data/entities/animals/crypt/wizard_tele.xml"] = { xml = "data/entities/animals/crypt/wizard_poly.xml" },
        ["data/entities/animals/barfer.xml"] = { xml = "data/entities/animals/crypt/wizard_poly.xml" },
        ["data/entities/animals/crypt/barfer.xml"] = { xml = "data/entities/animals/crypt/wizard_poly.xml" },

        -- spiders
        ["data/entities/animals/lukki/lukki.xml"] = { xml = "data/entities/animals/lukki/lukki_dark.xml" },
        ["data/entities/animals/lukki/lukki_longleg.xml"] = { xml = "data/entities/animals/lukki/lukki_dark.xml" },

        -- scorpion
        ["data/entities/animals/scorpion.xml"] = { xml = "data/entities/animals/boss_robot/boss_robot.xml" }, -- scorpions are rare and appear in temple, so upgrade to mecha kolmi to spice things up and cause chaos

        -- tentacler
        ["data/entities/animals/tentacler_small.xml"] = { xml = "data/entities/animals/crypt/tentacler.xml" },
        ["data/entities/animals/crypt/tentacler_small.xml"] = { xml = "data/entities/animals/crypt/tentacler.xml" },
        ["data/entities/animals/vault/tentacler_small.xml"] = { xml = "data/entities/animals/crypt/tentacler.xml" },

        -- healer
        ["data/entities/animals/scavenger_heal.xml"] = { xml = "data/entities/animals/scavenger_shield.xml" },
        ["data/entities/animals/drunk/scavenger_heal.xml"] = { xml = "data/entities/animals/scavenger_shield.xml" },
        ["data/entities/animals/rainforest/scavenger_heal.xml"] = { xml = "data/entities/animals/scavenger_shield.xml" },
        ["data/entities/animals/vault/scavenger_heal.xml"] = { xml = "data/entities/animals/scavenger_shield.xml" },
    }
    local pX, pY = EntityGetTransform(player)
    local upgradeTime = 2
    local maxHP = 50
    for i = 1, #enemies do
        local enemy = enemies[i]
        local path = EntityGetFilename(enemy)
        local upgrade = upgrades[path]
        local eX, eY = EntityGetTransform(enemy)
        if upgrade then
            
            if not RaytracePlatforms(pX,pY,eX,eY) then
                if not EntityHasTag(enemy, "isUpgrading") then
                    ComponentSetValue2(EntityAddComponent2(enemy, "VariableStorageComponent", {name = "upgradeFinishTime",value_int = GameGetFrameNum() + upgradeTime*60}), 0)
                    EntityAddTag(enemy, "isUpgrading")
                    local icon = EntityLoad("mods/twitch-integration/files/effects/upgrade_icon.xml", eX, eY)
                    EntityAddComponent2(
                        icon,
                        "UIIconComponent",
                        {
                            icon_sprite_file="mods/twitch-integration/files/effects/status_icons/enemy_upgrade.png",
                            name="Upgrading",
                            description="could get stronger",
                            is_perk=true,
                            display_above_head=true,
                            display_in_hud=true,
                        }
                    )
                    EntityAddChild(enemy, icon)
                end
            end
        end
        if EntityHasTag(enemy,"isUpgrading") then
            local components = EntityGetComponentIncludingDisabled(enemy, "VariableStorageComponent")
            local finishTime = -1
            upgrade = upgrades[path]
            for _, component in ipairs(components) do
                if ComponentGetValue2(component, "name") == "upgradeFinishTime" then
                    finishTime = ComponentGetValue2(component, "value_int")
                    break
                end
            end
            if GameGetFrameNum() >= finishTime and finishTime ~= -1 then
                local children = EntityGetAllChildren(enemy) or {}
                for _, child in ipairs(children) do
                    if EntityHasTag(child, "upgrade_icon") then
                        EntityKill(child)
                    end
                end
                local newEnemy = EntityLoad(upgrade.xml, eX, eY)
                local dmg_comp = EntityGetFirstComponentIncludingDisabled(newEnemy, "DamageModelComponent")
                if pY < 900 then 
                    local hp = ComponentGetValue2(dmg_comp, "hp")
                    local max_hp = ComponentGetValue2(dmg_comp, "max_hp")
                    if hp > maxHP/25 then
                        ComponentSetValue2(dmg_comp, "hp", maxHP/25)
                    end
                    if max_hp > maxHP/25 then
                        ComponentSetValue2(dmg_comp, "max_hp", maxHP/25)
                    end
                end
                EntityKill(enemy)
            end
        end

    end
end