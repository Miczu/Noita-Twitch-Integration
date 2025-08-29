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
    for i = 1, #enemies do
        local enemy = enemies[i]
        local name = EntityGetName(enemy)
        local upgrade = upgrades[name]

        if upgrade then
            local eX, eY = EntityGetTransform(enemy)
            EntityLoad(upgrade.xml, eX, eY)
            EntityKill(enemy)
        end
    end
end