player = EntityGetWithTag("player_unit")[1]
if player then
    local x, y = EntityGetTransform(player)
    local enemies = EntityGetInRadiusWithTag(x, y, 256, "enemy")
    local upgrades = {
        ["$animal_thundermage"] = {
            xml = "data/entities/animals/thundermage_big.xml"
        },
        ["$animal_firebug"] = {
            xml = "data/entities/animals/bigfirebug.xml"
        },
        ["$animal_firemage_weak"] = {
            xml = "data/entities/animals/firemage.xml"
        },
        ["$animal_necromancer_shop"] = {
            xml = "data/entities/animals/necromancer_super.xml"
        },
        ["$animal_worm_tiny"] = {
            xml = "data/entities/animals/meatmaggot.xml"
        },
        ["$animal_worm"] = {
            xml = "data/entities/animals/worm_skull.xml"
        },
        ["$animal_worm_big"] = {
            xml = "data/entities/animals/worm_end.xml"
        },
        ["$animal_zombie"] = {
            xml = "data/entities/animals/bigzombie.xml"
        },
        ["$animal_acidshooter"] = {
            xml = "data/entities/animals/crypt/acidshooter.xml"
        },
        ["$animal_slimeshooter"] = {
            xml = "data/entities/animals/lasershooter.xml"
        },
        ["$animal_shotgunner"] = {
            xml = "data/entities/animals/shotgunner_hell.xml"
        },
        ["$animal_miner"] = {
            xml = "data/entities/animals/miner_hell.xml"
        },
        ["$animal_sniper"] = {
            xml = "data/entities/animals/sniper_hell.xml"
        },
        ["$animal_fungus"] = {
            xml = "data/entities/animals/fungus_big.xml"
        },
        ["$animal_tank"] = {
            xml = "data/entities/animals/robobase/tank_super.xml"
        },
		["$animal_necrobot"] = {
            xml = "data/entities/animals/necrobot_super.xml"
        },
		["$animal_roboguard"] = {
            xml = "data/entities/animals/roboguard_big.xml"
        },
    }
    local pX, pY = EntityGetTransform(player)
    local upgradeTime = 1
    for i = 1, #enemies do
        local enemy = enemies[i]
        local name = EntityGetName(enemy)
        local upgrade = upgrades[name]
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
            upgrade = upgrades[name]
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
                EntityLoad(upgrade.xml, eX, eY)
                EntityKill(enemy)
            end
        end

    end
end