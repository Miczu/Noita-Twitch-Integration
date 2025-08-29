player = EntityGetWithTag("player_unit")[1]
if player then
    local x, y = EntityGetTransform(player)
    local enemies = EntityGetInRadiusWithTag(x, y, 256, "enemy")
    local upgrades = {
        ["$animal_thundermage"] = {
            msg = "Thunder Mage",
            xml = "data/entities/animals/thundermage_big.xml"
        },
        ["$animal_firebug"] = {
            msg = "Firefly",
            xml = "data/entities/animals/bigfirebug.xml"
        },
        ["$animal_firemage_weak"] = {
            msg = "Stendari",
            xml = "data/entities/animals/firemage.xml"
        },
        ["$animal_necromancer_shop"] = {
            msg = "Steve",
            xml = "data/entities/animals/necromancer_super.xml"
        },
        ["$animal_worm_tiny"] = {
            msg = "Tiny worm",
            xml = "data/entities/animals/meatmaggot.xml"
        },
        ["$animal_worm"] = {
            msg = "Worm",
            xml = "data/entities/animals/worm_skull.xml"
        },
        ["$animal_worm_big"] = {
            msg = "Big worm",
            xml = "data/entities/animals/worm_end.xml"
        },
        ["$animal_zombie"] = {
            msg = "Hound",
            xml = "data/entities/animals/bigzombie.xml"
        },
        ["$animal_acidshooter"] = {
            msg = "Acidshooter",
            xml = "data/entities/animals/crypt/acidshooter.xml"
        },
        ["$animal_slimeshooter"] = {
            msg = "Slimeshooter",
            xml = "data/entities/animals/lasershooter.xml"
        },
        ["$animal_shotgunner"] = {
            msg = "Shotgunner",
            xml = "data/entities/animals/shotgunner_hell.xml"
        },
        ["$animal_miner"] = {
            msg = "Miner",
            xml = "data/entities/animals/miner_hell.xml"
        },
        ["$animal_sniper"] = {
            msg = "Sniper",
            xml = "data/entities/animals/sniper_hell.xml"
        },
        ["$animal_fungus"] = {
            msg = "Fungus",
            xml = "data/entities/animals/fungus_big.xml"
        },
        ["$animal_tank"] = {
            msg = "Tank",
            xml = "data/entities/animals/robobase/tank_super.xml"
        },
		["$animal_necrobot"] = {
            msg = "necrobot",
            xml = "data/entities/animals/necrobot_super.xml"
        },
		["$animal_roboguard"] = {
            msg = "robo",
            xml = "data/entities/animals/roboguard_big.xml"
        },
    }
    for i = 1, #enemies do
        local enemy = enemies[i]
        local name = EntityGetName(enemy)
        local upgrade = upgrades[name]

        if upgrade then
            local eX, eY = EntityGetTransform(enemy)
            if upgrade.msg then
                GamePrintImportant(upgrade.msg)
            end
            EntityLoad(upgrade.xml, eX, eY)
            EntityKill(enemy)
        end
    end
end